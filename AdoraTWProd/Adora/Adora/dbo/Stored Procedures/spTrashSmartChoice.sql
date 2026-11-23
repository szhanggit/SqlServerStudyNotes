create proc spTrashSmartChoice @SessionId varchar(50), @IsSuccess bit output
as
begin
	SET NOCOUNT ON;

	BEGIN TRY
	BEGIN TRAN

		--insert new Transaction
		INSERT INTO [dbo].[Transaction]
				(AccountNumber,CallerIP,Channel,MerchantCode,ProgramCode,TranAmount,
				TranCodeRef,TranUtcDate,TranUtcDateTime,TranUtcDateTimeL,TranLocalDateTime,TranLocalDate,
				TranType,HostSSN,TranCode,TranGUID,ModifyVersion,BalanceAvailable,
				BalanceFrozen,SecurityKeyId,[Checksum],ResponseCode,TranRealDateTime, TerminalSSN)
		select buf.AccountNumber, buf.CallerIP, buf.Channel, buf.MerchantCode,buf.ProgramCode,buf.TranAmount,
			   buf.TranCodeRef,buf.TranUtcDate, buf.TranUtcDateTime,buf.TranUtcDateTimeL,buf.TranLocalDateTime,buf.TranLocalDate,
			   buf.TranType,buf.HostSsn,buf.TranCode, NEWID(),buf.ModifyVersion + 1, buf.BalanceAvailable,
			   buf.BalanceFrozen,buf.SecurityKeyId,buf.TransactionChecksum, '0000', buf.TranUtcDateTime, buf.TerminalSSN
			FROM dbo.TrashSmartChoiceBuffer buf WITH(NOLOCK) WHERE buf.SessionId = @SessionId
		
		--reverse Transaction or History
		if EXISTS(SELECT 1 FROM dbo.TrashSmartChoiceBuffer buf WITH(NOLOCK) WHERE buf.SessionId = @SessionId AND buf.IsTranHistory = 1)
		BEGIN
			UPDATE t set t.[Checksum] = buf.RedeemedTranChecksum
				,t.[RefundedAmount] = buf.RedeemedTranRefundedAmount
				,t.[Status] = 2
			FROM dbo.[TransactionHistory] t join dbo.TrashSmartChoiceBuffer buf WITH(NOLOCK) ON t.AccountNumber = buf.AccountNumber AND t.ProgramCode = buf.ProgramCode
			where buf.SessionId = @SessionId and buf.IsTranHistory = 1 AND t.TranType = 101
		END
        ELSE
        BEGIN
			UPDATE t set t.[Checksum] = buf.RedeemedTranChecksum
				,t.[RefundedAmount] = buf.RedeemedTranRefundedAmount
				,t.[Status] = 2
			FROM dbo.[Transaction] t join dbo.TrashSmartChoiceBuffer buf WITH(NOLOCK) ON t.AccountNumber = buf.AccountNumber AND t.ProgramCode = buf.ProgramCode
			where buf.SessionId = @SessionId and buf.IsTranHistory = 0  AND t.TranType = 101
		END
		
		--update account or History
		if EXISTS(SELECT 1 FROM dbo.TrashSmartChoiceBuffer WITH(NOLOCK) WHERE SessionId = @SessionId AND IsAccountHistory = 1)
		BEGIN
			UPDATE a SET 
				   [BalanceAvailable] = a.BalanceInitialized
				  ,[BalanceFrozen] = 0
				  ,[Checksum] = buf.AccountCheckSum
				  ,[TranCount] = a.TranCount
				  ,[TranAmountAccumulated] = a.TranAmountAccumulated - (a.BalanceInitialized - a.BalanceAvailable)
				  ,[ModifyVersion] = a.ModifyVersion + 1
				  ,[Status] = 8
				  ,[LastTranOn] = buf.TranUtcDateTime
				FROM dbo.AccountHistory a join dbo.TrashSmartChoiceBuffer buf ON a.AccountNumber = buf.AccountNumber and a.ProgramId = buf.ProgramId and a.ModifyVersion = buf.ModifyVersion
				where buf.SessionId = @SessionId AND buf.IsAccountHistory = 1

			IF @@ROWCOUNT <> 1
				THROW 51000, 'Account history updated by others', 1;

			INSERT INTO [dbo].[Account]
			SELECT a.* FROM dbo.AccountHistory a join dbo.TrashSmartChoiceBuffer buf ON a.AccountNumber = buf.AccountNumber and a.ProgramId = buf.ProgramId and a.ModifyVersion = buf.ModifyVersion + 1
				where buf.SessionId = @SessionId AND buf.IsAccountHistory = 1

			DELETE a FROM dbo.AccountHistory a join dbo.TrashSmartChoiceBuffer buf ON a.AccountNumber = buf.AccountNumber and a.ProgramId = buf.ProgramId and a.ModifyVersion = buf.ModifyVersion + 1
				WHERE buf.SessionId = @SessionId AND buf.IsAccountHistory = 1
		END
		ELSE
		BEGIN
			UPDATE a SET 
				   [BalanceAvailable] = a.BalanceInitialized
				  ,[BalanceFrozen] = 0
				  ,[Checksum] = buf.AccountCheckSum
				  ,[TranCount] = a.TranCount
				  ,[TranAmountAccumulated] = a.TranAmountAccumulated - (a.BalanceInitialized - a.BalanceAvailable)
				  ,[ModifyVersion] = a.ModifyVersion + 1
				  ,[Status] = 8
				  ,[LastTranOn] = buf.TranUtcDateTime
				FROM dbo.Account a join dbo.TrashSmartChoiceBuffer buf ON a.AccountNumber = buf.AccountNumber and a.ProgramId = buf.ProgramId and a.ModifyVersion = buf.ModifyVersion
				where buf.SessionId = @SessionId AND buf.IsAccountHistory = 0	
			
			IF @@ROWCOUNT <> 1
				THROW 51001, 'Account updated by others', 1;	
		END

		--update child account
		UPDATE a SET 
				   [BalanceAvailable] = a.BalanceInitialized
				  ,[BalanceFrozen] = 0
				  ,[Checksum] = buf.AccountCheckSum
				  ,[TranCount] = a.TranCount + 1
				  ,[TranAmountAccumulated] = a.TranAmountAccumulated - (a.BalanceInitialized - a.BalanceAvailable)
				  ,[ModifyVersion] = a.ModifyVersion + 1
				  ,[Status] = 8
				  ,[LastTranOn] = buf.TranUtcDateTime
				FROM dbo.Account a join dbo.TrashSmartChoiceBuffer buf ON a.AccountNumber = buf.AccountNumber and a.ProgramId = buf.ProgramId and a.ModifyVersion = buf.ModifyVersion
				where buf.SessionId = @SessionId AND buf.IsAccountHistory IS NULL

		IF @@ROWCOUNT <> 1
			THROW 51002, 'Child Account updated by others', 1;	

		delete dbo.TrashSmartChoiceBuffer where SessionId = @SessionId;

		set @IsSuccess = 1;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		set @IsSuccess = 0
		ROLLBACK TRANSACTION;
		delete dbo.TrashSmartChoiceBuffer where SessionId = @SessionId;
	END CATCH;		
end
