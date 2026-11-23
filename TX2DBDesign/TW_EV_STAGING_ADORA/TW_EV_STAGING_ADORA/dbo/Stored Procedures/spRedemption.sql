CREATE PROCEDURE [dbo].[spRedemption]
	@AccountNumber					varchar(50)
	,@ProgramId						int
	,@BalanceAvailable				int
	,@BalanceFrozen					int
	,@AccountCheckSum				varchar(50)
	,@ModifyVersion					int
	,@TransactionCheckSum			varchar(50)
	,@SecurityKeyId					int
	,@TranLocalDateTime				datetime
	,@TranLocalDate					int
	,@TranCode						varchar(50)
	,@Status						int
	,@LastTranOn					datetime
	,@ResponseCode					varchar(5) OUTPUT
	,@ConsumeTime					datetime = NULL
	,@ConsumeMerchantCode			varchar(50) = NULL
	,@ConsumeShopCode				varchar(50) = NULL
	,@ConsumeTerminalSSN			varchar(50) = NULL
	,@ChildAccountNumber			varchar(50) = NULL
	,@ChildProgramId				int
	,@ChildProductId				int = NULL
	,@MasterRedemptionTranAmount	int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
	DECLARE @MasterProgramIdentityCode varchar(20);
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
	 WHERE [AccountNumber] = @AccountNumber AND [ModifyVersion] = @ModifyVersion AND [ProgramId] = @ProgramId

	 IF @@ROWCOUNT <> 0
	 BEGIN
		SET @ResponseCode = '0000'

		UPDATE [dbo].[Transaction]
			SET [TranLocalDate] = @TranLocalDate
				,[TranLocalDateTime] = @TranLocalDateTime
				,[ResponseCode] = @ResponseCode
				,[ModifyVersion] = @ModifyVersion + 1
				,[BalanceAvailable] = @BalanceAvailable
				,[BalanceFrozen] = @BalanceFrozen
				,[CheckSum] = @TransactionCheckSum
				,[SecurityKeyId] = @SecurityKeyId
			WHERE [AccountNumber] = @AccountNumber AND [TranCode] = @TranCode
		
		IF EXISTS (SELECT 1 FROM dbo.MasterTranInfoStaging WHERE AccountNumber = @AccountNumber AND TranCode = @TranCode)
		BEGIN
			INSERT INTO dbo.MasterTranInfo
			SELECT AccountNumber, TranCode, ChildProductId, TranAmountRemain, VersionId 
			FROM dbo.MasterTranInfoStaging 
			WHERE AccountNumber = @AccountNumber AND TranCode = @TranCode
			
			DELETE dbo.MasterTranInfoStaging 
			WHERE AccountNumber = @AccountNumber AND TranCode = @TranCode
		END

		IF @ChildProductId > 0
		BEGIN
			INSERT dbo.MasterTranInfo
			(
				AccountNumber,
				TranCode,
				ChildProductId,
				TranAmountRemain,
				VersionId
			)
			VALUES
			(
				@AccountNumber, -- AccountNumber - varchar(50)
				@TranCode, -- TranCode - varchar(50)
				@ChildProductId,  -- ChildProductId - int
				@MasterRedemptionTranAmount,  -- TranAmountRemain - int
				0   -- VersionId - int
			)
		END

		IF @ChildAccountNumber IS NOT NULL
		BEGIN
		 	SELECT @MasterProgramIdentityCode = IdentityCode FROM Program WITH (NOLOCK) WHERE Id = @ProgramId
			UPDATE dbo.Account SET MasterRedemptionTranCode = @TranCode, MasterAccountNumber = @AccountNumber,MasterProgramIdentityCode = @MasterProgramIdentityCode, MasterRedemptionTranAmount = @MasterRedemptionTranAmount WHERE AccountNumber = @ChildAccountNumber AND ProgramId = @ChildProgramId
		END
	END
	ELSE
	BEGIN
		SET @ResponseCode = '0018'

		UPDATE [dbo].[Transaction]
			SET [TranLocalDate] = @TranLocalDate
				,[TranLocalDateTime] = @TranLocalDateTime
				,[ResponseCode] = @ResponseCode
				,[ModifyVersion] = @ModifyVersion
				,[BalanceAvailable] = @BalanceAvailable
				,[BalanceFrozen] = @BalanceFrozen
		 WHERE [AccountNumber] = @AccountNumber AND [TranCode] = @TranCode
	END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END