
CREATE PROCEDURE spDeleteAccountInfo2
	-- Add the parameters for the stored procedure here
	@AccountNumber varchar(50)
	,@ProgramCode varchar(50)
	,@BatchTransactionDetailId int
	,@BatchTransactionDetailExternalId int
	,@IsInHistory int
	,@ErrorMessage NVARCHAR(4000) OUTPUT
	,@ErrorLine INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
	
	Declare @ProgramId int = 0;
	select @ProgramId = Id from Program with(nolock) where IdentityCode = @ProgramCode;

	if @ProgramId > 0
	begin
		if @IsInHistory > 0
		begin		
			insert into [dbo].[AccountHistoryDelete] (
				[AccountNumber],
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
	[Comment]		
			)
			select
				[AccountNumber],
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
				@BatchTransactionDetailId as [BatchTransactionDetailId],
				@BatchTransactionDetailExternalId as [BatchTransactionDetailExternalId],
	null as [SessionId],
	GETDATE() as [BackupOn],
	'Manual' as [Channel],
	null as [Comment]
				from AccountHistory with(nolock)
			where AccountNumber = @AccountNumber AND ProgramId = @ProgramId;
		end
		else
		begin
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
			select [AccountNumber],
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
					@BatchTransactionDetailId as [BatchTransactionDetailId],
					@BatchTransactionDetailExternalId as [BatchTransactionDetailExternalId],
	null as [SessionId],
	GETDATE() as [BackupOn],
	'Manual' as [Channel],
	null as [Comment]
					from Account with(nolock) 
			where AccountNumber = @AccountNumber AND ProgramId = @ProgramId;
		end


			
		insert into AccountKeyDelete (AccountNumber, ProgramId, BatchTransactionDetailId, BatchTransactionDetailExternalId,
	[SessionId],
        [BackupOn],
	[Channel],
	[Comment])		
		select 
		AccountNumber, 
		ProgramId,  
		@BatchTransactionDetailId as [BatchTransactionDetailId],
		@BatchTransactionDetailExternalId as [BatchTransactionDetailExternalId],
	null as [SessionId],
	GETDATE() as [BackupOn],
	'Manual' as [Channel],
	null as [Comment]
		from AccountKey with(nolock)
		where AccountNumber = @AccountNumber AND ProgramId = @ProgramId;
	
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
		select [AccountNumber],
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
		@BatchTransactionDetailId as [BatchTransactionDetailId],
		@BatchTransactionDetailExternalId as [BatchTransactionDetailExternalId],
	null as [SessionId],
	GETDATE() as [BackupOn],
	'Manual' as [Channel],
	null as [Comment]
		from AccountToSync with(nolock)
		where AccountNumber = @AccountNumber AND ProgramId = @ProgramId;

		if @IsInHistory > 0
		begin
			delete from AccountHistory where AccountNumber = @AccountNumber AND ProgramId = @ProgramId;
		end
		else
		begin
			delete from Account where AccountNumber = @AccountNumber AND ProgramId = @ProgramId;
		end
		
		delete from AccountKey where AccountNumber = @AccountNumber AND ProgramId = @ProgramId;
		delete from AccountToSync where AccountNumber = @AccountNumber AND ProgramId = @ProgramId;
		delete from AccountBuffer1 where AccountNumber = @AccountNumber AND ProgramId = @ProgramId;
		delete from AccountBuffer2 where AccountNumber = @AccountNumber AND ProgramId = @ProgramId;
		delete from AccountBuffer3 where AccountNumber = @AccountNumber AND ProgramId = @ProgramId;
		delete from AccountBuffer4 where AccountNumber = @AccountNumber AND ProgramId = @ProgramId;

		update [Transaction]
		set ResponseCode = '9999'
		where AccountNumber = @AccountNumber AND ProgramCode = @ProgramCode;

		update [TransactionHistory]
		set ResponseCode = '9999'
		where AccountNumber = @AccountNumber AND ProgramCode = @ProgramCode;







	end

	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorLine = ERROR_LINE();
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;
	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END;