CREATE PROCEDURE dbo.spUpdateClientCredit
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @sessionId VARCHAR(50) = CONVERT(varchar(50),NEWID());

	UPDATE t SET 
			t.CreditAmount = (case p.ProductType when 1 then cqps.SoldPriceWithTax when 2 then IIF(p.ProductSubType <> 4, cqps.ValueBasedSoldPriceWithTax, obi.SoldPriceWithTax) ELSE 0 end) + ISNULL(st.SoldPriceWithTax, 0), 
			t.SessionId = @sessionId
		FROM dbo.CreditTransaction t WITH(NOLOCK)
		JOIN dbo.Voucher v WITH(NOLOCK) ON v.Id = t.VoucherId
		join dbo.Product p WITH(NOLOCK) ON p.Id = v.ProductId
		join dbo.OrderBeneficiaryInfo obi WITH(NOLOCK) ON obi.Id = v.BeneficiaryInfoId
		join dbo.OrderLine ol WITH(NOLOCK) ON ol.Id = obi.OrderLineId
		join dbo.ClientQuotationProduct cqp WITH(NOLOCK) ON cqp.Id = ol.ClientQuotationProductId
		join dbo.ClientQuotationProductSoldPrice cqps WITH(NOLOCK) ON cqps.ClientQuotationProductId = cqp.Id and cqps.ValidityFrom < obi.ActiveDate and cqps.ValidityEnd > obi.ActiveDate
		LEFT join dbo.ClientQuotationProductServiceFeeTriggerTime st WITH(NOLOCK) ON st.ClientQuotationProductId = cqp.Id

	BEGIN TRY
	BEGIN TRAN
		UPDATE cc SET cc.AvailableCredit = cc.AvailableCredit - amount, cc.ModifyVersion = cc.ModifyVersion + 1
			FROM dbo.ClientCredit cc
			JOIN 
				(SELECT c.Id, SUM(ct.CreditAmount) amount 
					FROM dbo.Client c WITH(NOLOCK)
					JOIN dbo.CreditTransaction ct WITH(NOLOCK) ON ct.ClientId = c.Id
					WHERE ct.SessionId = @sessionId
					GROUP BY c.Id
				) t ON t.Id = cc.ClientId

		UPDATE c SET c.CanIssue = 0
			OUTPUT Deleted.Id, 'CreditLimitJob', 1, 'close CanIssue', GETDATE() INTO dbo.CreditActionHistory(ClientId,Operater,ActionType,[Description],CreateDate)
			FROM dbo.Client c
			JOIN dbo.ClientCredit cc WITH(NOLOCK) ON cc.ClientId = c.Id
			WHERE cc.AvailableCredit <= 0 AND c.CanIssue = 1

		DELETE FROM CreditTransaction WHERE SessionId = @sessionId

		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		THROW;
	END CATCH
END
