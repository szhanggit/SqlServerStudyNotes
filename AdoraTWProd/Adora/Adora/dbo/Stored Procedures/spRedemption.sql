-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/04/24
-- Description:	Redemption.
-- =============================================
CREATE PROCEDURE spRedemption
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
	,@Status				int
	,@LastTranOn			datetime
	,@ResponseCode			varchar(5)	output
	,@ConsumeTime			datetime = null
	,@ConsumeMerchantCode	varchar(50) = null
    ,@ConsumeShopCode		varchar(50) = NULL
    ,@ConsumeTerminalSSN	varchar(50) = NULL
    ,@ChildAccountNumber   varchar(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
    UPDATE [dbo].[Account]
	   SET [BalanceAvailable] = @BalanceAvailable
		  ,[BalanceFrozen] = @BalanceFrozen
		  ,[Checksum] = @AccountCheckSum
		  ,[TranCount] = [TranCount] + 1
		  ,[TranAmountAccumulated] = [TranAmountAccumulated] + [BalanceAvailable] - @BalanceAvailable
		  ,[ModifyVersion] = [ModifyVersion] + 1
		  ,[Status] = @Status
		  ,[LastTranOn] = @LastTranOn
		  ,[ConsumeTime] = @ConsumeTime
		  ,[ConsumeMerchantCode] = @ConsumeMerchantCode
		  ,[ConsumeShopCode] = @ConsumeShopCode
		  ,[ConsumeTerminalSSN] = @ConsumeTerminalSSN
	 WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId

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

		 IF @ChildAccountNumber IS NOT NULL
		 BEGIN
			UPDATE dbo.Account SET MasterRedemptionTranCode = @TranCode WHERE AccountNumber = @ChildAccountNumber AND ProgramId = @ProgramId
		 END
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
