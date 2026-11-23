
CREATE PROCEDURE [dbo].[spInsertedExpiredAccounts]
	@SessionId			VARCHAR(50)
	,@ErrorMessage		VARCHAR(4000)	OUTPUT
	,@ErrorLine			INT				OUTPUT
	,@IsSuccess 		INT 			OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRAN

	BEGIN TRY
	
		
	insert into [Transaction] (AccountNumber, 
		ProgramCode, 
		MerchantCode, 
		HostSSN, 
		TerminalSSN, 
		TranUtcDate, 
		TranUtcDateTimeL, 
		TranUtcDateTime, 
		TranLocalDate, 
		TranLocalDateTime, 
		TranTerminalDateTime, 
		SettleDate, 
		TranRealDateTime, 
		ShopCode, 
		TerminalCode, 
		TranType,
		[Status], 
		TranAmount, 
		RefundedAmount, 
		ResponseCode, 
		IsCleared, 
		NodeNum, 
		CallerIP, 
		Channel, 
		[Parameters], 
		TranCode, 
		TranCodeRef, 
		TranGUID,
		TranGUIDRef, 
		ModifyVersion, 
		BalanceAvailable, 
		BalanceFrozen, 
		Checksum, 
		SecurityKeyId, 
		Rsv1, 
		Rsv2, 
		Rsv3, 
		ShiftCode, 
		BusinessDay, 
		MultiAccountsTransactionId)
	select 
		AccountNumber, 
		ProgramCode, 
		MerchantCode, 
		HostSSN, 
		TerminalSSN, 
		TranUtcDate, 
		TranUtcDateTimeL, 
		TranUtcDateTime, 
		TranLocalDate, 
		TranLocalDateTime, 
		TranTerminalDateTime, 
		SettleDate, 
		TranRealDateTime, 
		ShopCode, 
		TerminalCode, 
		TranType,
		[Status], 
		TranAmount, 
		RefundedAmount, 
		ResponseCode, 
		IsCleared, 
		NodeNum, 
		CallerIP, 
		Channel, 
		[Parameters], 
		TranCode, 
		TranCodeRef, 
		TranGUID,
		TranGUIDRef, 
		ModifyVersion, 
		BalanceAvailable, 
		BalanceFrozen, 
		Checksum, 
		SecurityKeyId, 
		Rsv1, 
		Rsv2, 
		Rsv3, 
		ShiftCode, 
		BusinessDay, 
		(case when MultiAccountsTransactionId = 0 then null else MultiAccountsTransactionId end) as MultiAccountsTransactionId
	from [TransactionForExpiredAccountBuffer] with(nolock)
	where SessionId = @SessionId;	
	
		DELETE [dbo].[TransactionExpTemp]
		WHERE SessionId = @SessionId;

		DELETE [dbo].[TransactionForExpiredAccountBuffer]
		WHERE SessionId = @SessionId;

		SET @IsSuccess = 1;

	END TRY
	BEGIN CATCH
		SET @IsSuccess = 0;
		SELECT @ErrorMessage = ERROR_MESSAGE()
		SELECT @ErrorLine = ERROR_LINE()

		IF EXISTS (SELECT 1 FROM SYSOBJECTS WHERE name = '#tmp_hostssn' )
			DROP TABLE #tmp_hostssn

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

			declare @errorSeverity int
					,@errorState int

			select @errorMessage = ERROR_MESSAGE()	
					,@errorSeverity = ERROR_SEVERITY()
					,@errorState = ERROR_STATE()	

			/*抛出一个异常*/
			raiserror (@errorMessage,@errorSeverity,@errorState)
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END

