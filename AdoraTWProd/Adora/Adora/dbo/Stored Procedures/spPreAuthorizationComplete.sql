-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/04/30
-- Description:	Compelte pre-authorization.
-- =============================================
CREATE PROCEDURE spPreAuthorizationComplete
	@AccountNumber						varchar(50)
	,@ProgramId							int
	,@BalanceAvailable					int
	,@BalanceFrozen						int
	,@AccountCheckSum					varchar(50)
	,@ModifyVersion						int
	,@TransactionCheckSum				varchar(50)
	,@SecurityKeyId						int
	,@TranLocalDateTime					datetime
	,@TranLocalDate						int
	,@TranCode							varchar(50)
	,@LastTranOn						datetime
	,@IsAccountHistory					bit
	,@Status							int
	,@TranCodeRef						varchar(50)
	,@PreviousTransactionChecksum		varchar(50)
	,@IsPreAuthorizedTransactionHistory	bit
	,@ResponseCode						varchar(5)	output
	,@ConsumeTime						datetime = null
	,@ConsumeMerchantCode				varchar(50) = null
    ,@ConsumeShopCode					varchar(50) =NULL
    ,@ConsumeTerminalSSN				varchar(50) =null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN
	BEGIN TRY

	if (@IsAccountHistory = 0)
	begin
		UPDATE [dbo].[Account]
		   SET [BalanceAvailable] = @BalanceAvailable
			  ,[BalanceFrozen] = @BalanceFrozen
			  ,[Checksum] = @AccountCheckSum
			  ,[ModifyVersion] = [ModifyVersion] + 1
			  ,[LastTranOn] = @LastTranOn
			  ,[Status] = @Status
			  ,[TranCount] = [TranCount] + 1
			  ,[TranAmountAccumulated] = [TranAmountAccumulated] + [BalanceAvailable] - @BalanceAvailable + [BalanceFrozen] - @BalanceFrozen
			  ,[ConsumeTime] = @ConsumeTime
			  ,[ConsumeMerchantCode] = @ConsumeMerchantCode
			  ,[ConsumeShopCode] = @ConsumeShopCode
			  ,[ConsumeTerminalSSN] = @ConsumeTerminalSSN
		 WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId
	end
	else
	begin
		UPDATE [dbo].[AccountHistory]
		   SET [BalanceAvailable] = @BalanceAvailable
			  ,[BalanceFrozen] = @BalanceFrozen
			  ,[Checksum] = @AccountCheckSum
			  ,[ModifyVersion] = [ModifyVersion] + 1
			  ,[LastTranOn] = @LastTranOn
			  ,[Status] = @Status
			  ,[TranCount] = [TranCount] + 1
			  ,[TranAmountAccumulated] = [TranAmountAccumulated] + [BalanceAvailable] - @BalanceAvailable
			  ,[ConsumeTime] = @ConsumeTime
			  ,[ConsumeMerchantCode] = @ConsumeMerchantCode
			  ,[ConsumeShopCode] = @ConsumeShopCode
			  ,[ConsumeTerminalSSN] = @ConsumeTerminalSSN
		 WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId
	end

	if @@ROWCOUNT <> 0
	begin
		if @IsPreAuthorizedTransactionHistory > 0
		begin
			UPDATE [dbo].[TransactionHistory]
				SET [Status] = 4
					,[CheckSum] = @PreviousTransactionChecksum
			WHERE [AccountNumber] = @AccountNumber AND [TranCode] = @TranCodeRef
		end
		else
		begin
			UPDATE [dbo].[Transaction]
				SET [Status] = 4
					,[CheckSum] = @PreviousTransactionChecksum
			WHERE [AccountNumber] = @AccountNumber AND [TranCode] = @TranCodeRef
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
	end
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END
