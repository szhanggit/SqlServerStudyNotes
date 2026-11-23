









CREATE PROCEDURE dbo.spReverseTrashVoucherCredit  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 BEGIN TRY  
 BEGIN TRAN  
 
	DECLARE @SessionId VARCHAR(50) = CONVERT(varchar(50),NEWID());  
	DECLARE @StartTime DATETIME;  
	DECLARE @EndTime DATETIME;  
	DECLARE @TransactionId  Bigint;  
	SET @StartTime = DATEADD(HOUR ,-2, GETDATE());  
	SET @EndTime = DATEADD(MINUTE ,-30, GETDATE());  

	select top 1 @TransactionId = TransactionId from ReverseCreditTransaction with(nolock) order by TransactionId desc  
	IF @TransactionId is NULL  
	BEGIN  
		select top 1 @TransactionId = Id from [Transaction] with(nolock) order by Id desc  
		set @TransactionId = @TransactionId -1000000  
	END  

	insert into dbo.ReverseCreditTransaction(CreditAmount,ClientId,VoucherId,TransactionId,SessionId)  
	SELECT (case p.ProductType when 1 then cqps.SoldPriceWithTax when 2 then IIF(p.ProductSubType <> 4, cqps.ValueBasedSoldPriceWithTax, obi.SoldPriceWithTax) ELSE 0 end) + ISNULL(st.SoldPriceWithTax, 0),  
		cc.ClientId, v.Id,t.Id,@SessionId  
	FROM dbo.Voucher v WITH(NOLOCK)  
		JOIN [Transaction] t with(nolock) on t.AccountNumber = v.VoucherNumber  
		JOIN dbo.Product p WITH(NOLOCK) ON p.Id = v.ProductId  
		JOIN dbo.OrderBeneficiaryInfo obi WITH(NOLOCK) ON obi.Id = v.BeneficiaryInfoId  
		JOIN dbo.OrderLine ol WITH(NOLOCK) ON ol.Id = obi.OrderLineId  
		JOIN dbo.[Order] o WITH(NOLOCK) ON o.Id = ol.OrderId  
		JOIN dbo.ClientQuotationProduct cqp WITH(NOLOCK) ON cqp.Id = ol.ClientQuotationProductId  
		JOIN dbo.ClientQuotationProductSoldPrice cqps WITH(NOLOCK) ON cqps.ClientQuotationProductId = cqp.Id and cqps.ValidityFrom <= obi.ActiveDate and cqps.ValidityEnd > obi.ActiveDate  
		JOIN dbo.ClientQuotation cq WITH(NOLOCK) ON cq.Id = o.ClientQuotationId  
		JOIN dbo.ClientCredit cc WITH(NOLOCK) ON cc.ClientId = cq.ClientId  
		LEFT join dbo.ClientQuotationProductServiceFeeTriggerTime st WITH(NOLOCK) ON st.ClientQuotationProductId = cqp.Id  
		left join ReverseCreditTransaction rct with(nolock) on rct.VoucherId = v.Id  
	WHERE v.[Status] = 8 AND o.Status = 64 and rct.VoucherId is NULL and t.Id>@TransactionId and t.TranType =404  

	insert into dbo.ClientCreditValue(Amount,ClientId,Source,CreatedOn,UpdatedOn,VoucherSessionId,Status)  
	SELECT SUM(ct.CreditAmount), c.Id, 'Trash', GETDATE(), GETDATE(), ct.SessionId, 0  
		FROM dbo.Client c WITH(NOLOCK)  
		JOIN dbo.ReverseCreditTransaction ct WITH(NOLOCK) ON ct.ClientId = c.Id  
		WHERE ct.SessionId = @SessionId  
		GROUP BY c.Id,ct.SessionId  	
	
	update TXCReverseCreditTransaction
	set SessionId = @SessionId  
	where SessionId is null
	
	insert into dbo.ClientCreditValue(Amount,ClientId,Source,CreatedOn,UpdatedOn,VoucherSessionId,Status)  
	SELECT SUM(ct.CreditAmount), c.Id, 'Trash', GETDATE(), GETDATE(), ct.SessionId, 0  
		FROM dbo.Client c WITH(NOLOCK)  
		JOIN dbo.TXCReverseCreditTransaction ct WITH(NOLOCK) ON ct.ClientId = c.Id  
		WHERE ct.SessionId = @SessionId  
		GROUP BY c.Id,ct.SessionId  
		
 COMMIT;  
 END TRY  
 BEGIN CATCH  
	ROLLBACK;  
	THROW;  
 END CATCH  
END  




