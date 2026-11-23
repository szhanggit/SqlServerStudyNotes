










CREATE PROCEDURE dbo.spCalculateClientCredit  
AS  
BEGIN  
 SET NOCOUNT ON;  
 BEGIN TRY  
 BEGIN TRAN  
	DECLARE @sessionId VARCHAR(50) = CONVERT(varchar(50),NEWID());  
	update ClientCreditValue set SessionId = @sessionId WHERE Status = 0  

	UPDATE cc SET cc.AvailableCredit = cc.AvailableCredit + amount, cc.ModifyVersion = cc.ModifyVersion + 1, UpdatedOn = GETDATE()  
	FROM dbo.ClientCredit cc  
		JOIN   
		(SELECT c.Id, SUM(ct.Amount) amount   
		 FROM dbo.Client c WITH(NOLOCK)  
		 JOIN dbo.ClientCreditValue ct WITH(NOLOCK) ON ct.ClientId = c.Id  
		 WHERE ct.SessionId = @sessionId  
		 GROUP BY c.Id  
		) t ON t.Id = cc.ClientId  

	UPDATE c SET c.CanIssue = 0  
		OUTPUT Deleted.Id, 'CreditLimitJob', 1, 'close CanIssue', GETDATE() INTO dbo.CreditActionHistory(ClientId,Operater,ActionType,[Description],CreateDate)  
		FROM dbo.Client c  
		JOIN dbo.ClientCredit cc WITH(NOLOCK) ON cc.ClientId = c.Id  
		WHERE cc.AvailableCredit <= 0 AND c.CanIssue = 1  

	update ClientCreditValue set Status = 1,UpdatedOn = GETDATE() WHERE SessionId = @sessionId  
  
 COMMIT;  
 END TRY  
 BEGIN CATCH  
  ROLLBACK;  
  THROW;  
 END CATCH  
END    
  
  
  
