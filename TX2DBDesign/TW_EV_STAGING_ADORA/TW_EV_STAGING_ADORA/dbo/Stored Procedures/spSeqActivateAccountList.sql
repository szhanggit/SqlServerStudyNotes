
CREATE PROCEDURE [dbo].[spSeqActivateAccountList]
@UpdatedTable SequenceNumberUTCTimeType READONLY,
@InsertedTable SequenceNumberUTCTimeType READONLY,
@CreatedUTCTime bigint,
@BusinessUnit varchar(50),
@SessionId varchar(50), 
@IsSuccess bit output
AS
BEGIN
    SET NOCOUNT ON;
	
	Declare @inserted table ([AccountNumber] varchar(50), [ProgramCode] varchar(20), [TranCode] varchar(50), MerchantCode VARCHAR (50), TranLocalDate INT);

	BEGIN TRY
	BEGIN TRAN
		DECLARE @UpdatedCount int;
		DECLARE @InsertedCount int;
		DECLARE @InitCount int;
		DECLARE @RetCount int;
		SET @RetCount  = 0;
		SET @UpdatedCount = (SELECT count(1) FROM @UpdatedTable);
		SET @InsertedCount = (SELECT count(1) FROM @InsertedTable);
		SET @InitCount = (SELECT count(1) FROM AccountBuffer3 with(NOLOCK) WHERE SessionId = @SessionId);
		
		UPDATE abar SET abar.CreatedUTCTime = @CreatedUTCTime from AccountBatchActivateRecords abar with(NOLOCK) INNER JOIN @UpdatedTable UT ON abar.SequenceNumber = UT.SequenceNumber AND abar.CreatedUTCTime = UT.CreatedUTCTime;
		set @RetCount = (@RetCount + @@ROWCOUNT);
		
		INSERT INTO AccountBatchActivateRecords SELECT SequenceNumber,CreatedUTCTime FROM @InsertedTable IT;
		set @RetCount = (@RetCount + @@ROWCOUNT);

		INSERT INTO [dbo].[Transaction]
				([AccountNumber],[ProgramCode],ShopCode,
				[MerchantCode],[TranUtcDateTimeL],[HostSSN],[TerminalSSN],[TranUtcDateTime],[TranType],[TranAmount],
				[TranCode],
				[TranGUID],[ModifyVersion],[BalanceAvailable],[SecurityKeyId],[Checksum],[TranLocalDate],[TranLocalDateTime],
				[ResponseCode],[TranRealDateTime],[TranUtcDate])
			OUTPUT INSERTED.[AccountNumber], INSERTED.[ProgramCode], INSERTED.[TranCode], INSERTED.[MerchantCode], INSERTED.[TranLocalDate]
			INTO @inserted				
			select buf.AccountNumber,(select [IdentityCode] FROM [dbo].[Program] where [Id] = buf.ProgramId),buf.ShopCode,
				buf.MerchantCode,buf.TranUtcDateTimeL,buf.HostSsn,buf.TerminalSSN,buf.LastTranOn,buf.TranType,buf.TranAmount,
				(select [IdentityCode] + buf.MerchantCode + substring(cast(buf.TranUtcDateTimeL as varchar(14)), 1, 8) + buf.HostSsn FROM [dbo].[Program] where [Id] = buf.ProgramId),
				NEWID(),buf.ModifyVersion + 1,buf.TranAmount,buf.SecurityKeyId,buf.TransactionChecksum,buf.TranLocalDate,buf.TranLocalDateTime,
				'0000',buf.LastTranOn,cast(substring(cast(buf.TranUtcDateTimeL as varchar(14)), 1, 8) as int)
			from Account a join AccountBuffer3 buf with(nolock) on a.AccountNumber = buf.AccountNumber and a.ProgramId = buf.ProgramId and a.ModifyVersion = buf.ModifyVersion where buf.SessionId = @SessionId
		set @RetCount = (@RetCount + @@ROWCOUNT);
		
		if @BusinessUnit = 'TW'
		begin
			INSERT INTO AccountLETransBuffer (AccountNumber, ProgramCode, TranCode, SessionId, MerchantCode, TranLocalDate)
			select AccountNumber, ProgramCode, TranCode, @SessionId as SessionId, MerchantCode, TranLocalDate from @inserted;
		end


		update a set a.[Checksum] = buf.AccountCheckSum
			,a.[TranCount] = a.[TranCount] + 1
			,a.[ModifyVersion] = a.[ModifyVersion] + 1
			,a.[Status] = buf.[Status]
			,a.[LastTranOn] = buf.LastTranOn
			,a.[ActiveFrom] = buf.ActiveFrom
			,a.[ActiveTo] = buf.ActiveTo
			,a.[ActivatedOn] = buf.ActivatedOn
		from Account a join AccountBuffer3 buf with(nolock) on a.AccountNumber = buf.AccountNumber and a.ProgramId = buf.ProgramId and a.ModifyVersion = buf.ModifyVersion
		where buf.SessionId = @SessionId
		
		set @RetCount = (@RetCount + @@ROWCOUNT);
		
		delete AccountBuffer3 where SessionId = @SessionId;
		
		IF (@RetCount = (@InitCount * 2 + @UpdatedCount + @InsertedCount))
		BEGIN
			set @IsSuccess = 1;
			COMMIT TRANSACTION;
		END
		ELSE
		BEGIN
			set @IsSuccess = 0
			ROLLBACK TRANSACTION;
			delete AccountBuffer3 where SessionId = @SessionId;
		END

	END TRY
	BEGIN CATCH
		select ERROR_MESSAGE() as Message;
		set @IsSuccess = 0
		ROLLBACK TRANSACTION;
		delete AccountBuffer3 where SessionId = @SessionId;
	END CATCH;		

END;
