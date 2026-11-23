
CREATE PROCEDURE spInsertVoucherFromBuffer @OrderId INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @step INT = 3000;
	DECLARE @StartSN INT = (SELECT COUNT(1) + 1 FROM dbo.Voucher WITH(NOLOCK) 
											JOIN dbo.OrderBeneficiaryInfo obi WITH(NOLOCK) ON obi.Id = Voucher.BeneficiaryInfoId
											JOIN dbo.OrderLine ol WITH(NOLOCK) ON ol.Id = obi.OrderLineId
											JOIN dbo.[Order] o WITH(NOLOCK) ON o.Id = ol.OrderId
											WHERE o.Id = @OrderId);
	DECLARE @EndSN INT = (SELECT MAX(OrderSN) FROM dbo.VoucherOrderBuffer WITH(NOLOCK) WHERE OrderId = @OrderId);

	WHILE @StartSN <= @EndSN
	BEGIN
		BEGIN TRAN
		BEGIN TRY
			--insert dbo.Voucher(ProgramId,VoucherNumber,ProductId,BeneficiaryInfoId,BalanceAvailable,[STATUS],ExpiryDate,[GUID],ReservationBatchId,CacheNode,ShortUrl,AuthCode,ExtendId,VSessionId,PinCode)
			--	SELECT ProgramId,VoucherNumber,ProductId,BeneficiaryInfoId,BalanceAvailable,[STATUS],ExpiryDate,[GUID],ReservationBatchId,CacheNode,ShortUrl,AuthCode,ExtendId,VSessionId,PinCode 
			--		FROM dbo.VoucherBuffer WITH(NOLOCK) WHERE OrderId = @OrderId ORDER BY Id OFFSET @StartSN - 1 rows fetch next @step rows only

			merge dbo.Voucher v
				using (select ProgramId,VoucherNumber,ProductId,BeneficiaryInfoId,BalanceAvailable,[STATUS],ExpiryDate,[GUID],ReservationBatchId,CacheNode,ShortUrl,AuthCode,ExtendId,VSessionId,PinCode from dbo.VoucherBuffer WITH(NOLOCK) WHERE OrderId = @OrderId ORDER BY Id OFFSET @StartSN - 1 rows fetch next @step rows only) b on v.VoucherNumber = b.VoucherNumber AND v.ProgramId = b.ProgramId
				when matched then update set 
					v.BeneficiaryInfoId = b.BeneficiaryInfoId, v.[Status] = b.[Status], v.ExpiryDate = b.ExpiryDate, v.CacheNode = b.CacheNode,
					v.ShortUrl = b.ShortUrl,v.AuthCode = b.AuthCode,v.VSessionId = b.VSessionId, v.PinCode = b.PinCode
				when not matched then 
					INSERT (ProgramId,VoucherNumber,ProductId,BeneficiaryInfoId,BalanceAvailable,[STATUS],ExpiryDate,[GUID],
						ReservationBatchId,CacheNode,ShortUrl,AuthCode,ExtendId,VSessionId,PinCode) 
					VALUES(ProgramId,VoucherNumber,ProductId,BeneficiaryInfoId,BalanceAvailable,[STATUS],ExpiryDate,[GUID],
						ReservationBatchId,CacheNode,ShortUrl,AuthCode,ExtendId,VSessionId,PinCode);

			SET @StartSN += @step;

			IF @StartSN <= @EndSN
			BEGIN
				COMMIT;
				CONTINUE;
			end
			
			DECLARE @CurrentDateTime DATETIME = GETDATE();

			--Trust Account
			IF EXISTS(SELECT 1 FROM dbo.OrderLine WITH(NOLOCK) WHERE  OrderId = @OrderId AND NeedTrustAccount = 1)
			BEGIN
				INSERT INTO dbo.VoucherTrustAccountBuffer(VoucherId, OrderLineTrustAccountId, SessionId)
					SELECT v.Id, ot.Id, v.VSessionId
						FROM dbo.Voucher v WITH(NOLOCK)
						JOIN dbo.OrderBeneficiaryInfo obi WITH(NOLOCK) ON obi.Id = v.BeneficiaryInfoId
						JOIN dbo.OrderLine ol WITH(NOLOCK) ON ol.Id = obi.OrderLineId
						JOIN dbo.[Order] o WITH(NOLOCK) ON o.Id = ol.OrderId
						JOIN dbo.OrderLineTrustAccount ot WITH(NOLOCK) ON ot.OrderLineId = ol.Id AND ot.ValidFrom <= @CurrentDateTime AND ot.ValidTo >= @CurrentDateTime
						WHERE ol.NeedTrustAccount = 1 AND o.Id = @OrderId
			END

			--HiLife
			IF EXISTS (SELECT 1 FROM dbo.[Order] o WITH(NOLOCK)
								JOIN dbo.OrderLine ol WITH(NOLOCK) ON ol.OrderId = o.Id
								JOIN dbo.ClientQuotationProduct cqp WITH(NOLOCK) ON cqp.Id = ol.ClientQuotationProductId
								JOIN dbo.ProductVersion pv WITH(NOLOCK) ON pv.Id = cqp.ProductVersionId
								JOIN dbo.Product p WITH(NOLOCK) ON p.Id = pv.ProductId 
								JOIN dbo.VoucherNumberRule r WITH(NOLOCK) ON r.Id = p.VoucherNumberRuleId
								WHERE o.Id = @OrderId AND r.VoucherGenerator = 2)
			BEGIN
				insert VoucherExtendCode(Id,Barcode1,Barcode2,CreatedOn) 
					SELECT v.Id, s.PropertyValue, v.VoucherNumber, @currentDateTime
						FROM dbo.[Order] o WITH(NOLOCK)
						JOIN dbo.OrderLine ol WITH(NOLOCK) ON ol.OrderId = o.Id
						JOIN dbo.OrderBeneficiaryInfo obi WITH(NOLOCK) ON obi.OrderLineId = ol.Id
						JOIN dbo.Voucher v WITH(NOLOCK) ON v.BeneficiaryInfoId = obi.Id
						JOIN dbo.Product p WITH(NOLOCK) ON p.Id = v.ProductId
						JOIN dbo.VoucherNumberRule r WITH(NOLOCK) ON r.Id = p.VoucherNumberRuleId
						JOIN dbo.ProductExternalProperty ext WITH(NOLOCK) ON ext.Id = p.ExternalPropertyId
						JOIN dbo.ProductExternalPropertySet s WITH(NOLOCK) ON s.ProductExternalPropertyId = ext.Id AND s.PropertyName = 'Barcode1'
						WHERE o.Id = @OrderId AND r.VoucherGenerator = 2
			END
		
			COMMIT;
		END TRY
		BEGIN CATCH
			ROLLBACK;
			THROW;
		END CATCH
	END
END
