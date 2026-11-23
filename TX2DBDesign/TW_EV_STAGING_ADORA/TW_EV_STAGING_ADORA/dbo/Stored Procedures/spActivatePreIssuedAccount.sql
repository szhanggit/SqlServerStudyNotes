CREATE PROCEDURE [dbo].[spActivatePreIssuedAccount]
	@AccountNumber						varchar(50)
	,@ProgramId							int
	,@AccountCheckSum					varchar(50)
	,@ModifyVersion						int
	,@Status							int
	,@LastTranOn						datetime
	,@ActiveFrom						datetime
	,@ActiveTo							datetime
	,@ActivatedOn						datetime
	,@Balance							int
	,@IsNotifyClient					bit
	,@ClientNotificationProviderCode	varchar(50)
	,@ExpirationPolicyId				int
	,@ExternalOrderId					varchar(50)
	,@MasterAccountNumber				varchar(50) = NULL
	,@MasterProgramIdentityCode			varchar(20) = NULL
	,@MasterRedemptionTranCode			varchar(50) = NULL
	,@MasterRedemptionTranAmount		int = NULL
	,@ChildProductId					int = NULL
	,@AccountBalanceUpdated				bit
	,@IsSuccess							bit output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @IsSuccess = 0

	BEGIN TRAN

	BEGIN TRY
		IF(@ClientNotificationProviderCode = '')
			SET @ClientNotificationProviderCode = NULL
		
		IF @MasterAccountNumber IS NOT NULL AND @MasterRedemptionTranCode IS NOT NULL AND @ChildProductId IS NOT NULL -- For deferred child
		BEGIN
			UPDATE dbo.MasterTranInfo
				SET TranAmountRemain = TranAmountRemain - @Balance, VersionId = VersionId + 1
				WHERE AccountNumber = @MasterAccountNumber 
					AND TranCode = @MasterRedemptionTranCode 
					AND ChildProductId = @ChildProductId 
					AND TranAmountRemain >= @Balance

			IF @@ROWCOUNT <> 1
			BEGIN
				SET @IsSuccess = 0
				ROLLBACK;
				RETURN;
			END
		END

		UPDATE [dbo].[Account]
			SET [Checksum] = @AccountCheckSum
				,[ModifyVersion] = [ModifyVersion] + 1
				,[Status] = @Status
				,[LastTranOn] = @LastTranOn
				,[CreatedOn] = @LastTranOn
				,[ActiveFrom] = @ActiveFrom
				,[ActiveTo] = @ActiveTo
				,[ActivatedOn] = @ActivatedOn
				,[IsNotifyClient] = @IsNotifyClient
				,[ClientNotificationProviderCode] = @ClientNotificationProviderCode
				,[ExpirationPolicyId] = @ExpirationPolicyId
				,[ExternalOrderId] = @ExternalOrderId
				,[MasterAccountNumber] = @MasterAccountNumber
				,[MasterProgramIdentityCode] = @MasterProgramIdentityCode
				,MasterRedemptionTranCode = ISNULL(@MasterRedemptionTranCode, MasterRedemptionTranCode)
				,[MasterRedemptionTranAmount] = @MasterRedemptionTranAmount
				,[BalanceAvailable] = IIF(@AccountBalanceUpdated = 1, @Balance, [BalanceAvailable])
				,[BalanceInitialized] = IIF(@AccountBalanceUpdated = 1, @Balance, [BalanceInitialized])
			WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId

		IF @@ROWCOUNT <> 0
		BEGIN
			DECLARE @ProgramCode varchar(20)
			SELECT @ProgramCode = [IdentityCode] FROM [dbo].[Program] WHERE [Id] = @ProgramId

			INSERT INTO [dbo].[AccountToGenTranV2] (AccountNumber, ProgramCode, TranAmount, TranType, PlanDateTime, ActiveTo)
			VALUES (@AccountNumber, @ProgramCode, @Balance, 401, GETUTCDATE(), @ActiveTo)

			INSERT INTO [dbo].[AccountToGenTranV2] (AccountNumber, ProgramCode, TranAmount, TranType, PlanDateTime, ActiveTo)
			VALUES (@AccountNumber, @ProgramCode, @Balance, 402, @ActiveFrom, @ActiveTo)

			SET @IsSuccess = 1
		END
		ELSE
		BEGIN
			SET @IsSuccess = 0
		END

	END TRY
	BEGIN CATCH
		SET @IsSuccess = 0
		ROLLBACK TRANSACTION
		RETURN
	END CATCH

	COMMIT TRANSACTION;
END