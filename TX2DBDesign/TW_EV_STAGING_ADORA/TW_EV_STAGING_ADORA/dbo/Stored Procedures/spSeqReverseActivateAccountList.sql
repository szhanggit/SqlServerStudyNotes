CREATE   PROCEDURE spSeqReverseActivateAccountList  
	@UpdatedTable SequenceNumberUTCTimeType READONLY,  
	@InsertedTable SequenceNumberUTCTimeType READONLY,  
	@CreatedUTCTime bigint,  
	@SessionId varchar(50),   
	@IsSuccess bit output  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 BEGIN TRY  
 BEGIN TRAN  
  DECLARE @UpdatedCount int;  
  DECLARE @InsertedCount int;  
  DECLARE @InitCount int;  
  DECLARE @RetCount int;  
  SET @RetCount  = 0;  
  SET @UpdatedCount = (SELECT count(1) FROM @UpdatedTable);  
  SET @InsertedCount = (SELECT count(1) FROM @InsertedTable);  
  SET @InitCount = (SELECT count(1) FROM AccountBuffer4 with(NOLOCK) WHERE SessionId = @SessionId);  
    
  UPDATE abrar SET abrar.CreatedUTCTime = @CreatedUTCTime from AccountBatchReverseActivateRecords abrar with(NOLOCK) INNER JOIN @UpdatedTable UT ON abrar.SequenceNumber = UT.SequenceNumber AND abrar.CreatedUTCTime = UT.CreatedUTCTime;  
  set @RetCount = (@RetCount + @@ROWCOUNT);  
    
  INSERT INTO AccountBatchReverseActivateRecords SELECT SequenceNumber,CreatedUTCTime FROM @InsertedTable IT;  
  set @RetCount = (@RetCount + @@ROWCOUNT);    
  
  UPDATE ab4  
	SET TranCodeRef = t.TranCode
  FROM AccountBuffer4 ab4
  INNER JOIN [Program] p ON ab4.ProgramId = p.Id 
  INNER JOIN [Transaction] t ON ab4.AccountNumber = t.AccountNumber AND t.ProgramCode = p.IdentityCode
  WHERE  t.ResponseCode = '0000' AND t.TranType = 402

  UPDATE t
	SET t.Status = 2
  FROM AccountBuffer4 ab4
  INNER JOIN [Program] p ON ab4.ProgramId = p.Id 
  INNER JOIN [Transaction] t ON ab4.AccountNumber = t.AccountNumber AND t.ProgramCode = p.IdentityCode AND ab4.TranCodeRef = t.TranCode
  WHERE  t.ResponseCode = '0000' AND t.TranType = 402
    
  INSERT INTO [dbo].[Transaction]  
    ([AccountNumber],[ProgramCode],  
    [MerchantCode],[ShopCode],[TranUtcDateTimeL],[HostSSN],[TerminalSSN],[TranUtcDateTime],[TranType],[TranAmount],  
    [TranCode],  
    [TranGUID],[ModifyVersion],[BalanceAvailable],[SecurityKeyId],[Checksum],[TranLocalDate],[TranLocalDateTime],  
    [ResponseCode],[TranRealDateTime],[TranUtcDate], [TranCodeRef])  
   select buf.AccountNumber,(select [IdentityCode] FROM [dbo].[Program] where [Id] = buf.ProgramId),  
    buf.MerchantCode,buf.ShopCode,buf.TranUtcDateTimeL,buf.HostSsn,buf.TerminalSSN,buf.LastTranOn,buf.TranType,buf.TranAmount,  
    (select [IdentityCode] + buf.MerchantCode + substring(cast(buf.TranUtcDateTimeL as varchar(14)), 1, 8) + buf.HostSsn FROM [dbo].[Program] where [Id] = buf.ProgramId),  
    NEWID(),buf.ModifyVersion + 1,buf.TranAmount,buf.SecurityKeyId,buf.TransactionChecksum,buf.TranLocalDate,buf.TranLocalDateTime,  
    '0000',buf.LastTranOn,cast(substring(cast(buf.TranUtcDateTimeL as varchar(14)), 1, 8) as int), buf.TranCodeRef  
   from Account a join AccountBuffer4 buf with(nolock) on a.AccountNumber = buf.AccountNumber and a.ProgramId = buf.ProgramId and a.ModifyVersion = buf.ModifyVersion where buf.SessionId = @SessionId  
  
  set @RetCount = (@RetCount + @@ROWCOUNT);  
  
  update a set a.[Checksum] = buf.AccountCheckSum  
   ,a.[TranCount] = a.[TranCount] + 1  
   ,a.[ModifyVersion] = a.[ModifyVersion] + 1  
   ,a.[Status] = buf.[Status]  
   ,a.[LastTranOn] = buf.LastTranOn  
   ,a.[ActiveFrom] = buf.ActiveFrom  
   ,a.[ActiveTo] = buf.ActiveTo  
   ,a.[ActivatedOn] = buf.ActivatedOn  
  from Account a join AccountBuffer4 buf with(nolock) on a.AccountNumber = buf.AccountNumber and a.ProgramId = buf.ProgramId and a.ModifyVersion = buf.ModifyVersion  
  where buf.SessionId = @SessionId  
  
  set @RetCount = (@RetCount + @@ROWCOUNT);  
  
  delete AccountBuffer4 where SessionId = @SessionId;  
  
  IF (@RetCount = (@InitCount * 2 + @UpdatedCount + @InsertedCount))  
  BEGIN  
   set @IsSuccess = 1;  
   COMMIT TRANSACTION;  
  END  
  ELSE  
  BEGIN  
   set @IsSuccess = 0  
   ROLLBACK TRANSACTION;  
   delete AccountBuffer4 where SessionId = @SessionId;  
  END  
 END TRY  
 BEGIN CATCH  
  set @IsSuccess = 0  
  ROLLBACK TRANSACTION;  
  delete AccountBuffer4 where SessionId = @SessionId;  
 END CATCH;    
END