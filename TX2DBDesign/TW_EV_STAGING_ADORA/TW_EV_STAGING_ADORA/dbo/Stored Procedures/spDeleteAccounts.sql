
CREATE PROCEDURE spDeleteAccounts
	@Step			INT,
	@TaskId		VARCHAR(50),
	@ErrorMessage	VARCHAR(4000)	OUTPUT,
	@ErrorLine		INT				OUTPUT,
	@IsSuccess 		INT 			OUTPUT,
	@IsLeft			INT				OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

	BEGIN TRAN
	BEGIN TRY
		update top(@Step) AccountDeletionBuffer
		set SessionId = 1
		where TaskId = @TaskId;
	

		insert into [dbo].[AccountDelete] ([AccountNumber],
				[ProgramId],
				[ProductId],
				[ExternalOrderId],
				[AccountNumberHashed],
				[BalanceAvailable],
				[BalanceFrozen],
				[ValueType],
				[TopupMode],
				[Status],
				[Checksum],
				[TranCount],
				[TranAmountAccumulated],
				[AcceptanceLoopId],
				[RestrictionId],
				[ExpirationPolicyId],
				[Password],
				[ActiveFrom],
				[ActiveTo],
				[CreatedOn],
				[LastTranOn],
				[LastTranDate],
				[LastTranTime],
				[BlockedOn],
				[ActivatedOn],
				[ExpiredOn],
				[ModifyVersion],
				[AccountNumberLength],
				[AccountGUID],
				[IsNotifyClient],
				[ClientNotificationProviderCode],
				[ConsumeTime],
				[ConsumeMerchantCode],
				[ConsumeShopCode],
				[ConsumeTerminalSSN],
				[BalanceInitialized],
				[PinCode],
				[MasterAccountNumber],
				[MasterRedemptionTranCode],
				[MasterProgramIdentityCode],
				[SequenceNumber],
				[BatchTransactionDetailId],
				[BatchTransactionDetailExternalId],
				[SessionId],
				[BackupOn],
				[Channel],
				[Comment])		
		select  a.[AccountNumber],
				a.[ProgramId],
				[ProductId],
				[ExternalOrderId],
				[AccountNumberHashed],
				[BalanceAvailable],
				[BalanceFrozen],
				[ValueType],
				[TopupMode],
				[Status],
				[Checksum],
				[TranCount],
				[TranAmountAccumulated],
				[AcceptanceLoopId],
				[RestrictionId],
				[ExpirationPolicyId],
				[Password],
				[ActiveFrom],
				[ActiveTo],
				[CreatedOn],
				[LastTranOn],
				[LastTranDate],
				[LastTranTime],
				[BlockedOn],
				[ActivatedOn],
				[ExpiredOn],
				[ModifyVersion],
				[AccountNumberLength],
				[AccountGUID],
				[IsNotifyClient],
				[ClientNotificationProviderCode],
				[ConsumeTime],
				[ConsumeMerchantCode],
				[ConsumeShopCode],
				[ConsumeTerminalSSN],
				[BalanceInitialized],
				[PinCode],
				[MasterAccountNumber],
				[MasterRedemptionTranCode],
				[MasterProgramIdentityCode],
				[SequenceNumber],
				'9999' as [BatchTransactionDetailId],
				'9999' as [BatchTransactionDetailExternalId],
				null as [SessionId],
				GETDATE() as [BackupOn],
				'ClearCache' as [Channel],
				null as [Comment]
				from Account a with(nolock) 
				inner join AccountDeletionBuffer buf with(nolock) on a.AccountNumber = buf.AccountNumber AND a.ProgramId = buf.ProgramId
		where buf.TaskId = @TaskId AND buf.SessionId = 1;



		delete top(@Step) a from Account a with(nolock) 
		inner join AccountDeletionBuffer buf with(nolock) on a.AccountNumber = buf.AccountNumber AND a.ProgramId = buf.ProgramId
		where buf.TaskId = @TaskId AND buf.SessionId = 1;


		insert into AccountKeyDelete (AccountNumber, ProgramId, BatchTransactionDetailId, BatchTransactionDetailExternalId,
		[SessionId],
        [BackupOn],
		[Channel],
		[Comment])		
		select 
		a.AccountNumber, 
		a.ProgramId,  
		'9999' as [BatchTransactionDetailId],
		'9999' as [BatchTransactionDetailExternalId],
		null as [SessionId],
		GETDATE() as [BackupOn],
		'ClearCache' as [Channel],
		null as [Comment]
		from AccountKey a with(nolock)
		inner join AccountDeletionBuffer buf with(nolock) on a.AccountNumber = buf.AccountNumber AND a.ProgramId = buf.ProgramId
		where buf.TaskId = @TaskId AND buf.SessionId = 1;




		delete top(@Step) a from AccountKey a with(nolock) 
		inner join AccountDeletionBuffer buf with(nolock) on a.AccountNumber = buf.AccountNumber AND a.ProgramId = buf.ProgramId
		where buf.TaskId = @TaskId AND buf.SessionId = 1;

		insert into AccountToSyncDelete ([AccountNumber],
		[ProgramId],
		[BalanceAvailable],
		[BalanceFrozen],
		[Status],
		[CreatedOn],
		[ActiveTo],
		[ActivatedOn],
		[ConsumeTime],
		[ConsumeMerchantCode],
		[ConsumeShopCode],
		[ChangedUTCTimeL],
		[ConsumeTerminalSSN],
		[LastTranOn],
		[BatchTransactionDetailId],
		[BatchTransactionDetailExternalId],
		[SessionId],
		[BackupOn],
		[Channel],
		[Comment]
		)
		select a.[AccountNumber],
		a.[ProgramId],
		[BalanceAvailable],
		[BalanceFrozen],
		[Status],
		[CreatedOn],
		[ActiveTo],
		[ActivatedOn],
		[ConsumeTime],
		[ConsumeMerchantCode],
		[ConsumeShopCode],
		[ChangedUTCTimeL],
		[ConsumeTerminalSSN],
		[LastTranOn],
		'9999' as [BatchTransactionDetailId],
		'9999' as [BatchTransactionDetailExternalId],
		null as [SessionId],
		GETDATE() as [BackupOn],
		'ClearCache' as [Channel],
		null as [Comment]
		from AccountToSync a with(nolock)
		inner join AccountDeletionBuffer buf with(nolock) on a.AccountNumber = buf.AccountNumber AND a.ProgramId = buf.ProgramId
		where buf.TaskId = @TaskId AND buf.SessionId = 1;





		insert into AccountLETransDelete (
		AId,
		AccountLEId,
		TranBalanceAvailable,
		TranAmount,
		TransLEStatus,
		TranType,
		TranCode,
		MerchantCode,
		SettleDate,
		TranLocalDate,
		CeatedDate,
		TransSessionId,
		BackupOn,
		Channel,
		Comment
		) select les.AId,
		les.AccountLEId,
		les.TranBalanceAvailable,
		les.TranAmount,
		les.TransLEStatus,
		les.TranType,
		les.TranCode,
		les.MerchantCode,
		les.SettleDate,
		les.TranLocalDate,
		les.CeatedDate,
		les.TransSessionId, 
		GETDATE() as [BackupOn],
		'Manual' as [Channel],
		null as [Comment]
		from AccountLE le with(nolock)
		inner join AccountLETrans les with(nolock) on le.Id = les.AccountLEId
		inner join AccountDeletionBuffer buf with(nolock) on le.AccountNumber = buf.AccountNumber AND le.ProgramId = buf.ProgramId
		where buf.TaskId = @TaskId AND buf.SessionId = 1;



		insert into AccountLEDelete (
		AccountLEId,
		ProgramId,
		ProgramCode,
		AccountNumber,
		BalanceAvailable,
		FinanceExpireDays,
		FinanceExpireDate,
		LEStatus,
		SessionId,
		LEInitBalance,
		InitBalance,
		BackupOn,
		Channel,
		Comment
		) select le.Id,
		le.ProgramId,
		le.ProgramCode,
		le.AccountNumber,
		le.BalanceAvailable,
		le.FinanceExpireDays,
		le.FinanceExpireDate,
		le.LEStatus,
		le.SessionId,
		le.LEInitBalance,
		le.InitBalance,
		GETDATE() as [BackupOn],
		'Manual' as [Channel],
		null as [Comment]
		from AccountLE le with(nolock)
		inner join AccountDeletionBuffer buf with(nolock) on le.AccountNumber = buf.AccountNumber AND le.ProgramId = buf.ProgramId
		where buf.TaskId = @TaskId AND buf.SessionId = 1;


		delete les from AccountLE le with(nolock)
		inner join AccountLETrans les with(nolock) on le.Id = les.AccountLEId
		inner join AccountDeletionBuffer buf with(nolock) on le.AccountNumber = buf.AccountNumber AND le.ProgramId = buf.ProgramId
		where buf.TaskId = @TaskId AND buf.SessionId = 1;

		delete le from AccountLE le with(nolock)
		inner join AccountDeletionBuffer buf with(nolock) on le.AccountNumber = buf.AccountNumber AND le.ProgramId = buf.ProgramId
		where buf.TaskId = @TaskId AND buf.SessionId = 1;








		delete top(@Step) a from AccountToSync a with(nolock) 
		inner join AccountDeletionBuffer buf with(nolock) on a.AccountNumber = buf.AccountNumber AND a.ProgramId = buf.ProgramId
		where buf.TaskId = @TaskId AND buf.SessionId = 1;

		delete from AccountDeletionBuffer where TaskId = @TaskId AND SessionId = 1;
		
		if exists (select * from AccountDeletionBuffer where TaskId = @TaskId)
		begin
			set @IsLeft = 1;
		end
		else
		begin
			set @IsLeft = 0;
		end

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

			/*æŠ›å‡ºä¸€ä¸ªå¼‚å¸¸*/
			raiserror (@errorMessage,@errorSeverity,@errorState)
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;	

END

