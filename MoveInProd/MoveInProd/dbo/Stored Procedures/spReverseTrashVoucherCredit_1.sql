CREATE PROCEDURE dbo.spReverseTrashVoucherCredit @batchlogId INT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
	BEGIN TRAN
		DECLARE @StartTime DATETIME = NULL;
		DECLARE @EndTime DATETIME = GETDATE();
		SELECT TOP 1 @StartTime = DataEndTime FROM dbo.BatchLog WITH(NOLOCK) WHERE BatchName = 'CreditLimitJob' AND Status = 8;
		IF @StartTime IS NULL
			SET @StartTime = DATEADD(DAY ,-1, GETDATE());

		UPDATE cc SET cc.AvailableCredit = cc.AvailableCredit + temp.IssueValue
		FROM dbo.ClientCredit cc
		JOIN(
			SELECT cc.Id, SUM((case p.ProductType when 1 then cqps.SoldPriceWithTax when 2 then IIF(p.ProductSubType <> 4, cqps.ValueBasedSoldPriceWithTax, obi.SoldPriceWithTax) ELSE 0 end) + ISNULL(st.SoldPriceWithTax, 0)) AS IssueValue
			FROM dbo.Voucher v WITH(NOLOCK)
			JOIN dbo.Product p WITH(NOLOCK) ON p.Id = v.ProductId
			JOIN dbo.OrderBeneficiaryInfo obi WITH(NOLOCK) ON obi.Id = v.BeneficiaryInfoId
			JOIN dbo.OrderLine ol WITH(NOLOCK) ON ol.Id = obi.OrderLineId
			JOIN dbo.[Order] o WITH(NOLOCK) ON o.Id = ol.OrderId
			JOIN dbo.ClientQuotationProduct cqp WITH(NOLOCK) ON cqp.Id = ol.ClientQuotationProductId
			JOIN dbo.ClientQuotationProductSoldPrice cqps WITH(NOLOCK) ON cqps.ClientQuotationProductId = cqp.Id and cqps.ValidityFrom < obi.ActiveDate and cqps.ValidityEnd > obi.ActiveDate
			JOIN dbo.ClientQuotation cq WITH(NOLOCK) ON cq.Id = o.ClientQuotationId
			JOIN dbo.ClientCredit cc WITH(NOLOCK) ON cc.ClientId = cq.ClientId
			LEFT join dbo.ClientQuotationProductServiceFeeTriggerTime st WITH(NOLOCK) ON st.ClientQuotationProductId = cqp.Id
			WHERE v.[Status] = 8 AND v.LastTranOn > @StartTime AND v.LastTranOn <= @EndTime AND o.Status = 64
			GROUP BY cc.Id
		) temp ON temp.Id = cc.Id

		UPDATE dbo.BatchLog SET DataStartTime = @StartTime, DataEndTime = @EndTime, [Status] = 8 WHERE Id = @batchlogId;

		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		THROW;
	END CATCH
END
