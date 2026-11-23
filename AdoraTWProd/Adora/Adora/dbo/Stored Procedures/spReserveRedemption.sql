-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/04/28
-- Description:	Reserve redemption.
-- =============================================
CREATE PROCEDURE spReserveRedemption
	@AccountNumber			varchar(50)
	,@ProgramId				int
	,@BalanceAvailable		int
	,@BalanceFrozen			int
	,@AccountCheckSum		varchar(50)
	,@ModifyVersion			int
	,@TransactionCheckSum	varchar(50)
	,@SecurityKeyId			int
	,@TranLocalDateTime		datetime
	,@TranLocalDate			int
	,@TranCode				varchar(50)
	,@ReversedTranCheckSum	varchar(50)
	,@IsTranHistory			bit
	,@CountDecrease			bit
	,@AmountDecrease		bit
	,@IsAccountHistory		bit
	,@ReversedTranCode		varchar(50)
	,@RefundedAmount		int
	,@Status				int
	,@LastTranOn			datetime
	,@childAccountNumber	varchar(50) = ''
	,@childProgramId	    int = 0
	,@ResponseCode			varchar(5)	output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
	
	if (LEN(@childAccountNumber) > 0 and @childProgramId > 0)
	begin
		UPDATE [dbo].[Account]
			SET 
				 [MasterAccountNumber] = null
				,[MasterProgramIdentityCode] = null
		WHERE [AccountNumber] = @childAccountNumber and [ProgramId] = @childProgramId

		UPDATE [dbo].[AccountHistory]
			SET 
				 [MasterAccountNumber] = null
				,[MasterProgramIdentityCode] = null
			WHERE [AccountNumber] = @childAccountNumber and [ProgramId] = @childProgramId
	end
	
	if (@IsAccountHistory = 0)
	begin
		if (@CountDecrease = 0 and @AmountDecrease = 0)
		begin
			UPDATE [dbo].[Account]
				SET [BalanceAvailable] = @BalanceAvailable
					,[BalanceFrozen] = @BalanceFrozen
					,[Checksum] = @AccountCheckSum
					,[ModifyVersion] = [ModifyVersion] + 1
					,[Status] = @Status
					,[LastTranOn] = @LastTranOn
				WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId
		end
		else if (@CountDecrease = 0 and @AmountDecrease = 1)
		begin
			UPDATE [dbo].[Account]
			   SET [BalanceAvailable] = @BalanceAvailable
				  ,[BalanceFrozen] = @BalanceFrozen
				  ,[Checksum] = @AccountCheckSum
				  ,[TranAmountAccumulated] = [TranAmountAccumulated] - (@BalanceAvailable - [BalanceAvailable])
				  ,[ModifyVersion] = [ModifyVersion] + 1
				  ,[Status] = @Status
				  ,[LastTranOn] = @LastTranOn
			 WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId
		end
		else if (@CountDecrease = 1 and @AmountDecrease = 0)
		begin
			UPDATE [dbo].[Account]
			   SET [BalanceAvailable] = @BalanceAvailable
				  ,[BalanceFrozen] = @BalanceFrozen
				  ,[Checksum] = @AccountCheckSum
				  ,[TranCount] = [TranCount] - 1
				  ,[ModifyVersion] = [ModifyVersion] + 1
				  ,[Status] = @Status
				  ,[LastTranOn] = @LastTranOn
			 WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId
		end
		else
		begin
			UPDATE [dbo].[Account]
			   SET [BalanceAvailable] = @BalanceAvailable
				  ,[BalanceFrozen] = @BalanceFrozen
				  ,[Checksum] = @AccountCheckSum
				  ,[TranCount] = [TranCount] - 1
				  ,[TranAmountAccumulated] = [TranAmountAccumulated] - (@BalanceAvailable - [BalanceAvailable])
				  ,[ModifyVersion] = [ModifyVersion] + 1
				  ,[Status] = @Status
				  ,[LastTranOn] = @LastTranOn
			 WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId
		end
		
	end
	else
	begin
		if (@CountDecrease = 0 and @AmountDecrease = 0)
		begin
			UPDATE [dbo].[AccountHistory]
				SET [BalanceAvailable] = @BalanceAvailable
					,[BalanceFrozen] = @BalanceFrozen
					,[Checksum] = @AccountCheckSum
					,[ModifyVersion] = [ModifyVersion] + 1
					,[Status] = @Status
					,[LastTranOn] = @LastTranOn
				WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId
		end
		else if (@CountDecrease = 0 and @AmountDecrease = 1)
		begin
			UPDATE [dbo].[AccountHistory]
			   SET [BalanceAvailable] = @BalanceAvailable
				  ,[BalanceFrozen] = @BalanceFrozen
				  ,[Checksum] = @AccountCheckSum
				  ,[TranAmountAccumulated] = [TranAmountAccumulated] - (@BalanceAvailable - [BalanceAvailable])
				  ,[ModifyVersion] = [ModifyVersion] + 1
				  ,[Status] = @Status
				  ,[LastTranOn] = @LastTranOn
			 WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId
		end
		else if (@CountDecrease = 1 and @AmountDecrease = 0)
		begin
			UPDATE [dbo].[AccountHistory]
			   SET [BalanceAvailable] = @BalanceAvailable
				  ,[BalanceFrozen] = @BalanceFrozen
				  ,[Checksum] = @AccountCheckSum
				  ,[TranCount] = [TranCount] - 1
				  ,[ModifyVersion] = [ModifyVersion] + 1
				  ,[Status] = @Status
				  ,[LastTranOn] = @LastTranOn
			 WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId
		end
		else
		begin
			UPDATE [dbo].[AccountHistory]
			   SET [BalanceAvailable] = @BalanceAvailable
				  ,[BalanceFrozen] = @BalanceFrozen
				  ,[Checksum] = @AccountCheckSum
				  ,[TranCount] = [TranCount] - 1
				  ,[TranAmountAccumulated] = [TranAmountAccumulated] - (@BalanceAvailable - [BalanceAvailable])
				  ,[ModifyVersion] = [ModifyVersion] + 1
				  ,[Status] = @Status
				  ,[LastTranOn] = @LastTranOn
			 WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId
		end

		INSERT INTO [dbo].[Account]
			   ([AccountNumber],[ProgramId],[ProductId],[ExternalOrderId],[AccountNumberHashed],[BalanceAvailable],[BalanceFrozen],[ValueType],[TopupMode],[Status],[Checksum],[TranCount]
			   ,[TranAmountAccumulated],[AcceptanceLoopId],[RestrictionId],[ExpirationPolicyId],[Password],[ActiveFrom],[ActiveTo],[CreatedOn],[LastTranOn],[BlockedOn],[ActivatedOn],[ExpiredOn]
			   ,[ModifyVersion],[AccountNumberLength],[AccountGUID],[IsNotifyClient],[ClientNotificationProviderCode],[ConsumeTime],[ConsumeMerchantCode],[ConsumeShopCode],[ConsumeTerminalSSN],[BalanceInitialized])
		 SELECT [AccountNumber],[ProgramId],[ProductId],[ExternalOrderId],[AccountNumberHashed],[BalanceAvailable],[BalanceFrozen],[ValueType],[TopupMode],[Status],[Checksum],[TranCount]
				,[TranAmountAccumulated],[AcceptanceLoopId],[RestrictionId],[ExpirationPolicyId],[Password],[ActiveFrom],[ActiveTo],[CreatedOn],[LastTranOn],[BlockedOn],[ActivatedOn],[ExpiredOn]
				,[ModifyVersion],[AccountNumberLength],[AccountGUID],[IsNotifyClient],[ClientNotificationProviderCode],[ConsumeTime],[ConsumeMerchantCode],[ConsumeShopCode],[ConsumeTerminalSSN],[BalanceInitialized]
		FROM [dbo].[AccountHistory]
		WHERE [AccountNumber] = @AccountNumber and [ProgramId] = @ProgramId

		DELETE FROM [dbo].[AccountHistory]
		WHERE [AccountNumber] = @AccountNumber and [ProgramId] = @ProgramId
	end

	 if @@ROWCOUNT <> 0
	 begin
		set @ResponseCode = '0000'

		UPDATE [dbo].[Transaction]
			SET [TranLocalDate] = @TranLocalDate
				,[TranLocalDateTime] = @TranLocalDateTime
				,[ResponseCode] = @ResponseCode
				,[ModifyVersion] = @ModifyVersion + 1
				,[BalanceAvailable] = @BalanceAvailable
				,[BalanceFrozen] = @BalanceFrozen
				,[CheckSum] = @TransactionCheckSum
				,[SecurityKeyId] = @SecurityKeyId
			WHERE [AccountNumber] = @AccountNumber and [TranCode] = @TranCode
		
		if (@IsTranHistory = 0)
		begin
			UPDATE [dbo].[Transaction]
			SET [CheckSum] = @ReversedTranCheckSum
				,[RefundedAmount] = @RefundedAmount
				,[Status] = 2
			WHERE [AccountNumber] = @AccountNumber and [TranCode] = @ReversedTranCode
		end
		else
		begin
			UPDATE [dbo].[TransactionHistory]
			SET [CheckSum] = @ReversedTranCheckSum
				,[RefundedAmount] = @RefundedAmount
				,[Status] = 2
			WHERE [AccountNumber] = @AccountNumber and [TranCode] = @ReversedTranCode
		end
	end
	else
	begin
		set @ResponseCode = '0018'

		UPDATE [dbo].[Transaction]
		   SET [TranLocalDate] = @TranLocalDate
			  ,[TranLocalDateTime] = @TranLocalDateTime
			  ,[ResponseCode] = @ResponseCode
			  ,[ModifyVersion] = @ModifyVersion
			  ,[BalanceAvailable] = @BalanceAvailable
			  ,[BalanceFrozen] = @BalanceFrozen
		 WHERE [AccountNumber] = @AccountNumber and [TranCode] = @TranCode
	end
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END
