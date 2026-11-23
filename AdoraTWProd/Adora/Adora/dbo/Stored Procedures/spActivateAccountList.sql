
CREATE PROCEDURE dbo.spActivateAccountList
@BusinessUnit varchar(50),
@SessionId varchar(50), 
@IsSuccess bit output
AS
BEGIN
    SET NOCOUNT ON;
	Declare @inserted table ([AccountNumber] varchar(50), [ProgramCode] varchar(20), [TranCode] varchar(50), MerchantCode VARCHAR (50), TranLocalDate INT);

	BEGIN TRY
	BEGIN TRAN

		INSERT INTO [dbo].[Transaction]
				([AccountNumber],[ProgramCode],
				[MerchantCode],[TranUtcDateTimeL],[HostSSN],[TerminalSSN],[TranUtcDateTime],[TranType],[TranAmount],
				[TranCode],
				[TranGUID],[ModifyVersion],[BalanceAvailable],[SecurityKeyId],[Checksum],[TranLocalDate],[TranLocalDateTime],
				[ResponseCode],[TranRealDateTime],[TranUtcDate])
			OUTPUT INSERTED.[AccountNumber], INSERTED.[ProgramCode], INSERTED.[TranCode], INSERTED.[MerchantCode], INSERTED.[TranLocalDate]
			INTO @inserted				
			select buf.AccountNumber,(select [IdentityCode] FROM [dbo].[Program] where [Id] = buf.ProgramId),
				buf.MerchantCode,buf.TranUtcDateTimeL,buf.HostSsn,buf.TerminalSSN,buf.LastTranOn,buf.TranType,buf.TranAmount,
				(select [IdentityCode] + buf.MerchantCode + substring(cast(buf.TranUtcDateTimeL as varchar(14)), 1, 8) + buf.HostSsn FROM [dbo].[Program] where [Id] = buf.ProgramId),
				NEWID(),buf.ModifyVersion + 1,buf.TranAmount,buf.SecurityKeyId,buf.TransactionChecksum,buf.TranLocalDate,buf.TranLocalDateTime,
				'0000',buf.LastTranOn,cast(substring(cast(buf.TranUtcDateTimeL as varchar(14)), 1, 8) as int)
			from Account a with(paglock) join AccountBuffer3 buf with(paglock) on a.AccountNumber = buf.AccountNumber and a.ProgramId = buf.ProgramId and a.ModifyVersion = buf.ModifyVersion where buf.SessionId = @SessionId

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
		from Account a with(paglock) join AccountBuffer3 buf with(paglock) on a.AccountNumber = buf.AccountNumber and a.ProgramId = buf.ProgramId and a.ModifyVersion = buf.ModifyVersion
		where buf.SessionId = @SessionId

		delete AccountBuffer3 where SessionId = @SessionId;

		set @IsSuccess = 1;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		select ERROR_MESSAGE() as Message;
		set @IsSuccess = 0
		ROLLBACK TRANSACTION;
		delete AccountBuffer3 where SessionId = @SessionId;
	END CATCH;		

END;

