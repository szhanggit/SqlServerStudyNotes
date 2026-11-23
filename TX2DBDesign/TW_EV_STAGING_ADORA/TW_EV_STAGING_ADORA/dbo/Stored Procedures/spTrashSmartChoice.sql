CREATE PROCEDURE [dbo].[spTrashSmartChoice] 
	@SessionId varchar(50), 
	@IsSuccess bit output  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 BEGIN TRY  
 BEGIN TRAN  
  
  -- Insert new transaction  
  INSERT INTO [dbo].[Transaction]  
   (AccountNumber, CallerIP, Channel, MerchantCode, ProgramCode, TranAmount,  
   TranCodeRef, TranUtcDate, TranUtcDateTime, TranUtcDateTimeL, TranLocalDateTime, TranLocalDate,  
   TranType, HostSSN, TranCode, TranGUID, ModifyVersion, BalanceAvailable,  
   BalanceFrozen, SecurityKeyId, [Checksum], ResponseCode, TranRealDateTime, TerminalSSN)  
  SELECT buf.AccountNumber, buf.CallerIP, buf.Channel, buf.MerchantCode, buf.ProgramCode,buf.TranAmount,  
   buf.TranCodeRef, buf.TranUtcDate, buf.TranUtcDateTime, buf.TranUtcDateTimeL, buf.TranLocalDateTime, buf.TranLocalDate,  
   buf.TranType, buf.HostSsn, buf.TranCode, NEWID(), buf.ModifyVersion + 1, buf.BalanceAvailable,  
   buf.BalanceFrozen, buf.SecurityKeyId, buf.TransactionChecksum, '0000', buf.TranUtcDateTime, buf.TerminalSSN  
  FROM dbo.TrashSmartChoiceBuffer buf WITH (NOLOCK) WHERE buf.SessionId = @SessionId  
    
  -- Reverse transaction or history  
  IF EXISTS(SELECT 1 FROM dbo.TrashSmartChoiceBuffer buf WITH (NOLOCK) WHERE buf.SessionId = @SessionId AND buf.IsTranHistory = 1)  
  BEGIN  
   UPDATE t   
    SET t.[Checksum] = buf.RedeemedTranChecksum,  
     t.[RefundedAmount] = buf.RedeemedTranRefundedAmount,  
     t.[Status] = 2  
   FROM dbo.[TransactionHistory] t JOIN dbo.TrashSmartChoiceBuffer buf WITH (NOLOCK)   
    ON t.AccountNumber = buf.AccountNumber AND t.ProgramCode = buf.ProgramCode AND T.TranCode = buf.TranCodeRef   
   WHERE buf.SessionId = @SessionId AND buf.IsTranHistory = 1 AND t.TranType = 101  
  END  
        IF EXISTS(SELECT 1 FROM dbo.TrashSmartChoiceBuffer buf WITH (NOLOCK) WHERE buf.SessionId = @SessionId AND buf.IsTranHistory = 0)  
        BEGIN  
   UPDATE t   
    SET t.[Checksum] = buf.RedeemedTranChecksum,  
     t.[RefundedAmount] = buf.RedeemedTranRefundedAmount,  
     t.[Status] = 2  
   FROM dbo.[Transaction] t JOIN dbo.TrashSmartChoiceBuffer buf WITH (NOLOCK)   
    ON t.AccountNumber = buf.AccountNumber AND t.ProgramCode = buf.ProgramCode AND T.TranCode = buf.TranCodeRef   
   WHERE buf.SessionId = @SessionId AND buf.IsTranHistory = 0  AND t.TranType = 101  
  END  
    
  DECLARE @childNumber INT = 0  
  SELECT @childNumber = COUNT(1) - 1 FROM (SELECT DISTINCT AccountNumber FROM dbo.TrashSmartChoiceBuffer WHERE SessionId = @SessionId) t;  
  
  DECLARE @ModifyVersion INT = (SELECT MIN(ModifyVersion) FROM TrashSmartChoiceBuffer WHERE SessionId = @SessionId AND IsAccountHistory = 0);  
  
  -- Update account or history  
  if EXISTS(SELECT 1 FROM dbo.TrashSmartChoiceBuffer WITH (NOLOCK) WHERE SessionId = @SessionId AND IsAccountHistory = 1)  
  BEGIN  
  
   SET @ModifyVersion = (SELECT MIN(ModifyVersion) FROM TrashSmartChoiceBuffer WHERE SessionId = @SessionId AND IsAccountHistory = 1);  
   UPDATE a   
    SET [BalanceAvailable] = a.BalanceInitialized,  
     [BalanceFrozen] = 0,  
     [Checksum] = buf.AccountCheckSum,  
     [TranCount] = a.TranCount,  
     [TranAmountAccumulated] = a.TranAmountAccumulated - (a.BalanceInitialized - a.BalanceAvailable),  
     [ModifyVersion] = a.ModifyVersion + 1,  
     [Status] = 8,  
     [LastTranOn] = buf.TranUtcDateTime  
    FROM dbo.AccountHistory a   
    JOIN (SELECT TOP 1 * FROM dbo.TrashSmartChoiceBuffer WHERE SessionId = @SessionId AND IsAccountHistory = 1 ORDER BY ModifyVersion DESC) buf  
     ON a.AccountNumber = buf.AccountNumber AND a.ProgramId = buf.ProgramId AND a.ModifyVersion = @ModifyVersion  
  
   IF @@ROWCOUNT <> 1  
    THROW 51000, 'Account history updated by others', 1;  
  
   INSERT INTO [dbo].[Account]  
   SELECT a.* FROM dbo.AccountHistory a JOIN dbo.TrashSmartChoiceBuffer buf   
    ON a.AccountNumber = buf.AccountNumber AND a.ProgramId = buf.ProgramId AND a.ModifyVersion = buf.ModifyVersion + 1  
   WHERE buf.SessionId = @SessionId AND buf.IsAccountHistory = 1  
  
   DELETE a FROM dbo.AccountHistory a JOIN dbo.TrashSmartChoiceBuffer buf   
    ON a.AccountNumber = buf.AccountNumber AND a.ProgramId = buf.ProgramId AND a.ModifyVersion = buf.ModifyVersion + 1  
   WHERE buf.SessionId = @SessionId AND buf.IsAccountHistory = 1  
   
  END  
  ELSE  
  BEGIN  
  
   UPDATE a   
    SET [BalanceAvailable] = a.BalanceInitialized,  
     [BalanceFrozen] = 0,  
     [Checksum] = buf.AccountCheckSum,  
     [TranCount] = a.TranCount,  
     [TranAmountAccumulated] = a.TranAmountAccumulated - (a.BalanceInitialized - a.BalanceAvailable),  
     [ModifyVersion] = a.ModifyVersion + 1,  
     [Status] = 8,  
     [LastTranOn] = buf.TranUtcDateTime  
    FROM dbo.Account a   
    JOIN (SELECT TOP 1 * FROM dbo.TrashSmartChoiceBuffer WHERE SessionId = @SessionId AND IsAccountHistory = 0 ORDER BY ModifyVersion DESC) buf  
     ON a.AccountNumber = buf.AccountNumber AND a.ProgramId = buf.ProgramId AND a.ModifyVersion = @ModifyVersion  
     
   IF @@ROWCOUNT <> 1  
    THROW 51001, 'Account updated by others', 1;  
	
  END  
  
  -- Update child account  
  UPDATE a   
   SET [BalanceAvailable] = a.BalanceInitialized,  
    [BalanceFrozen] = 0,  
    [Checksum] = buf.AccountCheckSum,  
    [TranCount] = a.TranCount + 1,  
    [TranAmountAccumulated] = a.TranAmountAccumulated - (a.BalanceInitialized - a.BalanceAvailable),  
    [ModifyVersion] = a.ModifyVersion + 1,  
    [Status] = 8,  
    [LastTranOn] = buf.TranUtcDateTime  
   FROM dbo.Account a JOIN dbo.TrashSmartChoiceBuffer buf   
    ON a.AccountNumber = buf.AccountNumber AND a.ProgramId = buf.ProgramId AND a.ModifyVersion = buf.ModifyVersion  
   WHERE buf.SessionId = @SessionId AND buf.IsAccountHistory IS NULL  
  
  IF @@ROWCOUNT <> @childNumber  
   THROW 51002, 'Child Account updated by others', 1;  
  
  DELETE dbo.TrashSmartChoiceBuffer WHERE SessionId = @SessionId;  
  
  SET @IsSuccess = 1;  
  COMMIT TRANSACTION;  
 END TRY  
 BEGIN CATCH  
  SET @IsSuccess = 0  
  ROLLBACK TRANSACTION;  
  delete dbo.TrashSmartChoiceBuffer WHERE SessionId = @SessionId;  
 END CATCH;  
END