
CREATE PROCEDURE spCleanAccountBatch
	@ErrorMessage			nvarchar(4000)	OUTPUT
	,@ErrorLine				int				OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT 1 FROM dbo.ArchiveAccountBuffer)
	BEGIN
		INSERT dbo.ArchiveAccountBuffer
		(
		    AccountNumber,
		    ProgramId,
		    ProductId,
		    ExternalOrderId,
		    AccountNumberHashed,
		    BalanceAvailable,
		    BalanceFrozen,
		    ValueType,
		    TopupMode,
		    Status,
		    Checksum,
		    TranCount,
		    TranAmountAccumulated,
		    AcceptanceLoopId,
		    RestrictionId,
		    ExpirationPolicyId,
		    Password,
		    ActiveFrom,
		    ActiveTo,
		    CreatedOn,
		    LastTranOn,
		    BlockedOn,
		    ActivatedOn,
		    ExpiredOn,
		    ModifyVersion,
		    AccountNumberLength,
		    AccountGUID,
		    IsNotifyClient,
		    ClientNotificationProviderCode,
		    ConsumeTime,
		    ConsumeMerchantCode,
		    ConsumeShopCode,
		    ConsumeTerminalSSN,
		    BalanceInitialized,
		    PinCode,
		    MasterAccountNumber,
		    MasterRedemptionTranCode,
		    MasterProgramIdentityCode,
		    SequenceNumber,
		    MasterRedemptionTranAmount,
		    ExecuteStatus,
		    SessionId
		)
		SELECT AccountNumber,
		    ProgramId,
		    ProductId,
		    ExternalOrderId,
		    AccountNumberHashed,
		    BalanceAvailable,
		    BalanceFrozen,
		    ValueType,
		    TopupMode,
		    Status,
		    Checksum,
		    TranCount,
		    TranAmountAccumulated,
		    AcceptanceLoopId,
		    RestrictionId,
		    ExpirationPolicyId,
		    Password,
		    ActiveFrom,
		    ActiveTo,
		    CreatedOn,
		    LastTranOn,
		    BlockedOn,
		    ActivatedOn,
		    ExpiredOn,
		    ModifyVersion,
		    AccountNumberLength,
		    AccountGUID,
		    IsNotifyClient,
		    ClientNotificationProviderCode,
		    ConsumeTime,
		    ConsumeMerchantCode,
		    ConsumeShopCode,
		    ConsumeTerminalSSN,
		    BalanceInitialized,
		    PinCode,
		    MasterAccountNumber,
		    MasterRedemptionTranCode,
		    MasterProgramIdentityCode,
		    SequenceNumber,
		    MasterRedemptionTranAmount,
		    0,
		    NULL
			FROM dbo.Account WITH(NOLOCK)
			WHERE [Status] IN (4, 8, 32) AND [LastTranOn]< DATEADD(DAY,-180,GETUTCDATE())
	END

	--delete account
	DECLARE @rowCount INT = 2000;
	DECLARE @deleteRowCount INT;
	DECLARE @insertRowCount INT;
	DECLARE @SessionId VARCHAR(50);
	WHILE @rowCount = 2000
	BEGIN
		BEGIN TRAN
		BEGIN TRY
			SET @SessionId = CONVERT(VARCHAR(50), NEWID());
			UPDATE TOP(2000) dbo.ArchiveAccountBuffer SET ExecuteStatus = 1, SessionId = @SessionId WHERE ExecuteStatus = 0;
			SET @rowCount = @@ROWCOUNT;

			IF @rowCount > 0
			BEGIN
				DELETE a
					FROM dbo.Account a
					JOIN dbo.ArchiveAccountBuffer buf ON buf.AccountNumber = a.AccountNumber AND buf.ProgramId = a.ProgramId
					WHERE buf.SessionId = @SessionId;
			END

			IF @rowCount <> @deleteRowCount
			BEGIN
				SELECT @ErrorMessage = N'delete Account fail'
				SELECT @ErrorLine = 129

				ROLLBACK;
				RETURN;
			END
			ELSE
				COMMIT;
		END TRY
		BEGIN CATCH
			SELECT @ErrorMessage = ERROR_MESSAGE()
			SELECT @ErrorLine = ERROR_LINE()

			ROLLBACK;
			RETURN;
		END CATCH
	END

	--insert accounthistory
	SET @rowCount = 2000;
	WHILE @rowCount >= 2000
	BEGIN
		BEGIN TRAN
		BEGIN TRY
			SET @SessionId = CONVERT(VARCHAR(50), NEWID());
			UPDATE TOP(2000) dbo.ArchiveAccountBuffer SET ExecuteStatus = 2, SessionId = @SessionId WHERE ExecuteStatus = 1;
			SET @rowCount = @@ROWCOUNT;

			IF @rowCount > 0
			BEGIN
				INSERT dbo.AccountHistory
				(
				    AccountNumber,
				    ProgramId,
				    ProductId,
				    ExternalOrderId,
				    AccountNumberHashed,
				    BalanceAvailable,
				    BalanceFrozen,
				    ValueType,
				    TopupMode,
				    Status,
				    Checksum,
				    TranCount,
				    TranAmountAccumulated,
				    AcceptanceLoopId,
				    RestrictionId,
				    ExpirationPolicyId,
				    Password,
				    ActiveFrom,
				    ActiveTo,
				    CreatedOn,
				    LastTranOn,
				    --LastTranDate,
				    --LastTranTime,
				    BlockedOn,
				    ActivatedOn,
				    ExpiredOn,
				    ModifyVersion,
				    AccountNumberLength,
				    AccountGUID,
				    IsNotifyClient,
				    ClientNotificationProviderCode,
				    ConsumeTime,
				    ConsumeMerchantCode,
				    ConsumeShopCode,
				    ConsumeTerminalSSN,
				    BalanceInitialized,
				    PinCode,
				    MasterAccountNumber,
				    MasterRedemptionTranCode,
				    MasterProgramIdentityCode,
				    SequenceNumber,
				    MasterRedemptionTranAmount
				)
				SELECT AccountNumber,
					ProgramId,
					ProductId,
					ExternalOrderId,
					AccountNumberHashed,
					BalanceAvailable,
					BalanceFrozen,
					ValueType,
					TopupMode,
					Status,
					Checksum,
					TranCount,
					TranAmountAccumulated,
					AcceptanceLoopId,
					RestrictionId,
					ExpirationPolicyId,
					Password,
					ActiveFrom,
					ActiveTo,
					CreatedOn,
					LastTranOn,
					BlockedOn,
					ActivatedOn,
					ExpiredOn,
					ModifyVersion,
					AccountNumberLength,
					AccountGUID,
					IsNotifyClient,
					ClientNotificationProviderCode,
					ConsumeTime,
					ConsumeMerchantCode,
					ConsumeShopCode,
					ConsumeTerminalSSN,
					BalanceInitialized,
					PinCode,
					MasterAccountNumber,
					MasterRedemptionTranCode,
					MasterProgramIdentityCode,
					SequenceNumber,
					MasterRedemptionTranAmount
					FROM dbo.ArchiveAccountBuffer WITH(NOLOCK)
					WHERE SessionId = @SessionId;
			END

			SET @insertRowCount = @@ROWCOUNT;

			IF @rowCount <> @insertRowCount
			BEGIN
				SELECT @ErrorMessage = N'insert AccountHistory fail'
				SELECT @ErrorLine = '252'

				ROLLBACK;
				RETURN;
			END
			ELSE
				COMMIT;
		END TRY
		BEGIN CATCH
			SELECT @ErrorMessage = ERROR_MESSAGE()
			SELECT @ErrorLine = ERROR_LINE()

			ROLLBACK;
			RETURN;
		END CATCH
	END

	--clear data
	IF NOT EXISTS (SELECT 1 FROM dbo.ArchiveAccountBuffer WHERE ExecuteStatus <> 2)
		TRUNCATE TABLE dbo.ArchiveAccountBuffer;

END
