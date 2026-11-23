-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/5/29
-- Description:	Clean account.
-- =============================================
CREATE PROCEDURE spCleanAccountBatch
	@ErrorMessage			nvarchar(4000)	OUTPUT
	,@ErrorLine				int				OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRAN

	BEGIN TRY

     SELECT [AccountNumber],[ProgramId],[ProductId],[ExternalOrderId],[AccountNumberHashed],[BalanceAvailable],[BalanceFrozen],[ValueType],[TopupMode],[Status],[Checksum],[TranCount]
           ,[TranAmountAccumulated],[AcceptanceLoopId],[RestrictionId],[ExpirationPolicyId],[Password],[ActiveFrom],[ActiveTo],[CreatedOn],[LastTranOn],[BlockedOn],[ActivatedOn]
           ,[ExpiredOn],[ModifyVersion],[AccountNumberLength],[AccountGUID],[IsNotifyClient],[ClientNotificationProviderCode],[ConsumeTime],[ConsumeMerchantCode],[ConsumeShopCode],[ConsumeTerminalSSN],[BalanceInitialized]
           ,[PinCode],[MasterAccountNumber],[MasterRedemptionTranCode],[MasterProgramIdentityCode]
	INTO #TempAccount
	FROM [dbo].[Account]
	WHERE [Status] IN (4, 8, 32)
	  AND [LastTranOn]< DATEADD(DAY,-180,GETUTCDATE())

	INSERT INTO [dbo].[AccountHistory]
           ([AccountNumber],[ProgramId],[ProductId],[ExternalOrderId],[AccountNumberHashed],[BalanceAvailable],[BalanceFrozen],[ValueType],[TopupMode],[Status],[Checksum],[TranCount]
           ,[TranAmountAccumulated],[AcceptanceLoopId],[RestrictionId],[ExpirationPolicyId],[Password],[ActiveFrom],[ActiveTo],[CreatedOn],[LastTranOn],[BlockedOn],[ActivatedOn]
           ,[ExpiredOn],[ModifyVersion],[AccountNumberLength],[AccountGUID],[IsNotifyClient],[ClientNotificationProviderCode],[ConsumeTime],[ConsumeMerchantCode],[ConsumeShopCode],[ConsumeTerminalSSN],[BalanceInitialized]
           ,[PinCode],[MasterAccountNumber],[MasterRedemptionTranCode],[MasterProgramIdentityCode])
	SELECT [AccountNumber],[ProgramId],[ProductId],[ExternalOrderId],[AccountNumberHashed],[BalanceAvailable],[BalanceFrozen],[ValueType],[TopupMode],[Status],[Checksum],[TranCount]
           ,[TranAmountAccumulated],[AcceptanceLoopId],[RestrictionId],[ExpirationPolicyId],[Password],[ActiveFrom],[ActiveTo],[CreatedOn],[LastTranOn],[BlockedOn],[ActivatedOn]
           ,[ExpiredOn],[ModifyVersion],[AccountNumberLength],[AccountGUID],[IsNotifyClient],[ClientNotificationProviderCode],[ConsumeTime],[ConsumeMerchantCode],[ConsumeShopCode],[ConsumeTerminalSSN],[BalanceInitialized]
           ,[PinCode],[MasterAccountNumber],[MasterRedemptionTranCode],[MasterProgramIdentityCode]
	FROM #TempAccount

		DELETE A FROM [dbo].[Account] A
		INNER JOIN #TempAccount TA ON A.AccountNumber=TA.AccountNumber AND A.ProgramId=TA.ProgramId

		DROP TABLE #TempAccount
	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE()
		SELECT @ErrorLine = ERROR_LINE()

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END
