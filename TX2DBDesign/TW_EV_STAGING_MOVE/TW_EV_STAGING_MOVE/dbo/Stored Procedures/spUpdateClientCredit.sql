








CREATE PROCEDURE dbo.spUpdateClientCredit  
AS  
BEGIN  
	SET NOCOUNT ON;  
	
 BEGIN TRY  
 BEGIN TRAN  
 
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
	join dbo.ClientQuotationProductSoldPrice cqps WITH(NOLOCK) ON cqps.ClientQuotationProductId = cqp.Id and cqps.ValidityFrom <= obi.ActiveDate and cqps.ValidityEnd > obi.ActiveDate  
	LEFT join dbo.ClientQuotationProductServiceFeeTriggerTime st WITH(NOLOCK) ON st.ClientQuotationProductId = cqp.Id  
	WHERE t.SessionId IS NULL  
	
	UPDATE t SET   
	t.SessionId = @sessionId  
	FROM dbo.TXCCreditTransaction t WITH(NOLOCK)  
	WHERE t.SessionId IS NULL  
  

 
	insert into dbo.ClientCreditValue(Amount,ClientId,Source,CreatedOn,UpdatedOn,VoucherSessionId,Status)  
	SELECT 0-SUM(ct.CreditAmount), c.Id, 'API Issue', GETDATE(), GETDATE(), ct.SessionId, 0  
		 FROM dbo.Client c WITH(NOLOCK)  
		 JOIN dbo.CreditTransaction ct WITH(NOLOCK) ON ct.ClientId = c.Id  
		 WHERE ct.SessionId = @sessionId  
		 GROUP BY c.Id,ct.SessionId   
		 
		
	insert into dbo.ClientCreditValue(Amount,ClientId,Source,CreatedOn,UpdatedOn,VoucherSessionId,Status)  
	SELECT 0-SUM(ct.CreditAmount), c.Id, 'API Issue', GETDATE(), GETDATE(), ct.SessionId, 0  
		 FROM dbo.Client c WITH(NOLOCK)  
		 JOIN dbo.TXCCreditTransaction ct WITH(NOLOCK) ON ct.ClientId = c.Id  
		 WHERE ct.SessionId = @sessionId  
		 GROUP BY c.Id,ct.SessionId   
	 
 COMMIT;  
 END TRY  
 BEGIN CATCH  
	ROLLBACK;  
	THROW;  
 END CATCH  
END  



