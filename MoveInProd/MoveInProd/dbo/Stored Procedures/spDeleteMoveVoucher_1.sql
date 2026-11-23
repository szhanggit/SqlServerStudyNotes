
CREATE PROCEDURE spDeleteMoveVoucher
	-- Add the parameters for the stored procedure here
	@VoucherNumber varchar(50)
	,@ProgramCode varchar(50)
	,@BatchTransactionDetailId int
	,@BatchTransactionDetailExternalId int
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




-------------
	insert into DeletedConsumeConfirmationInfo (DeletedConsumeConfirmationInfoId,VoucherId,
	ConfirmationInfo,
	LastUpdatedOn,
	BatchTransactionDetailId,
	SessionId,
	BackupOn,
	Channel,
	Comment)
	select cci.Id as DeletedConsumeConfirmationInfoId,VoucherId,ConfirmationInfo,LastUpdatedOn,
	1 as BatchTransactionDetailId, null as SessionId, GETDATE() as BackupOn, 'Manual' as Channel, null as Comment from ConsumeConfirmationInfo cci with(nolock)
	inner join Voucher v with(nolock) on cci.VoucherId = v.Id 
	inner join Program p with(nolock) on v.ProgramId = p.Id
	where v.VoucherNumber = @VoucherNumber AND p.IdentityCode = @ProgramCode


	delete cci from ConsumeConfirmationInfo cci with(nolock)
	inner join Voucher v with(nolock) on cci.VoucherId = v.Id 
	inner join Program p with(nolock) on v.ProgramId = p.Id
	where v.VoucherNumber = @VoucherNumber AND p.IdentityCode = @ProgramCode



	insert into DeletedVoucherTrustAccount (
	DeletedVoucherTrustAccountId,
	TrustAccountId,
	TrustAmountOption,
	TrustAccountBatchNo,
	Amount,
	ExpiryPolicyId,
	ExpiryDate,
	BatchTransactionDetailId,
	SessionId,
	BackupOn,
	Channel,
	Comment
	)
	select vta.Id as DeletedVoucherTrustAccountId,
	vta.TrustAccountId,
	vta.TrustAmountOption,
	vta.TrustAccountBatchNo,
	vta.Amount,
	vta.ExpiryPolicyId,
	vta.ExpiryDate,
	1 as BatchTransactionDetailId,
	null as SessionId,
	getdate() as BackupOn,
	'Manual' as Channel,
	null as Comment
	from VoucherTrustAccount vta with(nolock) 
	inner join Voucher v with(nolock) on vta.Id = v.Id
	inner join Program p with(nolock) on v.ProgramId = p.Id
	where v.VoucherNumber = @VoucherNumber AND p.IdentityCode = @ProgramCode

	delete vta from VoucherTrustAccount vta with(nolock) 
	inner join Voucher v with(nolock) on vta.Id = v.Id
	inner join Program p with(nolock) on v.ProgramId = p.Id
	where v.VoucherNumber = @VoucherNumber AND p.IdentityCode = @ProgramCode


	insert into DeletedDistributionTaskMessageVoucher (
	DeletedDistributionTaskMessageVoucherId,
	DistributionTaskMessageId,
	VoucherId,
	BatchTransactionDetailId,
	SessionId,
	BackupOn,
	Channel,
	Comment
	)
	select dtv.Id as DeletedDistributionTaskMessageVoucherId,
	dtv.DistributionTaskMessageId,
	dtv.VoucherId,
	1 as BatchTransactionDetailId,
	null as SessionId,
	getdate() as BackupOn,
	'Manual' as Channel,
	null as Comment
	from DistributionTaskMessageVoucher dtv with(nolock)
	inner join Voucher v with(nolock) on dtv.VoucherId = v.Id
	inner join Program p with(nolock) on v.ProgramId = p.Id
	where v.VoucherNumber = @VoucherNumber AND p.IdentityCode = @ProgramCode

	delete dtv from DistributionTaskMessageVoucher dtv with(nolock)
	inner join Voucher v with(nolock) on dtv.VoucherId = v.Id
	inner join Program p with(nolock) on v.ProgramId = p.Id
	where v.VoucherNumber = @VoucherNumber AND p.IdentityCode = @ProgramCode



	insert into DeletedDistributionTaskMessage (
	DeletedDistributionTaskMessageId,
	DistributionTaskId,
	VoucherId,
	DistributionStatus,
	Memo,
	BatchTransactionDetailId,
	SessionId,
	BackupOn,
	Channel,
	Comment)
	select dtm.Id as DeletedConsumeConfirmationInfoId,dtm.DistributionTaskId,dtm.VoucherId,dtm.DistributionStatus,dtm.Memo,
	1 as BatchTransactionDetailId, null as SessionId, GETDATE() as BackupOn, 'Manual' as Channel, null as Comment 
	from DistributionTaskMessage dtm with(nolock)
	inner join Voucher v with(nolock) on dtm.VoucherId = v.Id 
	inner join Program p with(nolock) on v.ProgramId = p.Id
	where v.VoucherNumber = @VoucherNumber AND p.IdentityCode = @ProgramCode

	delete dtm from DistributionTaskMessage dtm with(nolock)
	inner join Voucher v with(nolock) on dtm.VoucherId = v.Id 
	inner join Program p with(nolock) on v.ProgramId = p.Id
	where v.VoucherNumber = @VoucherNumber AND p.IdentityCode = @ProgramCode



	insert into DeletedVoucherCombo ( 	
	DeletedVoucherId,
	MasterVoucherId,
	ChildVoucherId,
	[Status],
	ComboOn,
	MasterRedemptionTranCode,
	UncomboOn,
	UncomboBy,
	[BatchTransactionDetailId],
	[SessionId],
	[BackupOn],
	[Channel],
	[Comment] )
	select 
	vc.Id as DeletedVoucherId,
	vc.MasterVoucherId,
	vc.ChildVoucherId,
	vc.[Status],
	vc.ComboOn,
	vc.MasterRedemptionTranCode,
	vc.UncomboOn,
	vc.UncomboBy,
	1 as [BatchTransactionDetailId],
	null as [SessionId],
	GETDATE() as [BackupOn],
	'Manual' as [Channel],
	null as [Comment]
	from VoucherCombo vc with(nolock)
	inner join Voucher v with(nolock) on vc.MasterVoucherId = v.Id
	where v.VoucherNumber = @VoucherNumber AND v.ProgramId = @ProgramId

	delete vc from VoucherCombo vc with(nolock)
	inner join Voucher v with(nolock) on vc.MasterVoucherId = v.Id
	where v.VoucherNumber = @VoucherNumber AND v.ProgramId = @ProgramId

	insert into DeletedVoucherCombo ( 	
	DeletedVoucherId,
	MasterVoucherId,
	ChildVoucherId,
	[Status],
	ComboOn,
	MasterRedemptionTranCode,
	UncomboOn,
	UncomboBy,
	[BatchTransactionDetailId],
	[SessionId],
	[BackupOn],
	[Channel],
	[Comment] )
	select 
	vc.Id as DeletedVoucherId,
	vc.MasterVoucherId,
	vc.ChildVoucherId,
	vc.[Status],
	vc.ComboOn,
	vc.MasterRedemptionTranCode,
	vc.UncomboOn,
	vc.UncomboBy,
	1 as [BatchTransactionDetailId],
	null as [SessionId],
	GETDATE() as [BackupOn],
	'Manual' as [Channel],
	null as [Comment]
	from VoucherCombo vc with(nolock)
	inner join Voucher v with(nolock) on vc.ChildVoucherId = v.Id
	where v.VoucherNumber = @VoucherNumber AND v.ProgramId = @ProgramId

	delete vc from VoucherCombo vc with(nolock)
	inner join Voucher v with(nolock) on vc.ChildVoucherId = v.Id
	where v.VoucherNumber = @VoucherNumber AND v.ProgramId = @ProgramId


	insert into DeletedVoucherActionHistory (
		VoucherActionHistoryId,
		VoucherId,
		ActionType,
		ActionResult,
		Operator,
		ActionTime,
		Memo,
		[BatchTransactionDetailId],
		[SessionId],
		[BackupOn],
		[Channel],
		[Comment]
	)
	select vah.Id as VoucherActionHistoryId, vah.VoucherId, vah.ActionType, vah.ActionResult, vah.Operator, vah.ActionTime, vah.Memo, '9999' as [BatchTransactionDetailId],
	null as [SessionId],
	GETDATE() as [BackupOn],
	'Manual' as [Channel],
	null as [Comment]
	from Voucher v with(nolock)
	inner join VoucherActionHistory vah with(nolock) on v.Id = vah.VoucherId
	where v.VoucherNumber = @VoucherNumber AND v.ProgramId = @ProgramId

	delete vah from Voucher v with(nolock)
	inner join VoucherActionHistory vah with(nolock) on v.Id = vah.VoucherId
	where v.VoucherNumber = @VoucherNumber AND v.ProgramId = @ProgramId


	insert into DeletedVoucher (
		VoucherId,
		ProgramId,
		VoucherNumber,
		ProductId,
		BeneficiaryInfoId,
		BalanceAvailable,
		BalanceFrozen,
		[Status],
		DistributionEmailStatus,
		EmailServiceProviderCode,
		DistributionEmailMemo,
		DistributionSLMSStatus,
		SLMSServiceProviderCode,
		DistributionSLMSMemo,
		PublishedOn,
		ActivatedOn,
		ExpiryDate,
		Memo,
		[GUID],
		ReservationBatchId,
		ConsumeTime,
		ConsumeMerchantCode,
		ConsumeShopCode,
		CacheNode,
		ConsumeTerminalSSN,
		LastTranOn,
		TrashReason,
		ShortUrl,
		AuthCode,
		ExtendId,
		VSessionId,
		PinCode,
		[BatchTransactionDetailId],
		[SessionId],
		[BackupOn],
		[Channel],
		[Comment]
	) select 	
		Id as VoucherId,
		ProgramId,
		VoucherNumber,
		ProductId,
		BeneficiaryInfoId,
		BalanceAvailable,
		BalanceFrozen,
		[Status],
		DistributionEmailStatus,
		EmailServiceProviderCode,
		DistributionEmailMemo,
		DistributionSLMSStatus,
		SLMSServiceProviderCode,
		DistributionSLMSMemo,
		PublishedOn,
		ActivatedOn,
		ExpiryDate,
		Memo,
		[GUID],
		ReservationBatchId,
		ConsumeTime,
		ConsumeMerchantCode,
		ConsumeShopCode,
		CacheNode,
		ConsumeTerminalSSN,
		LastTranOn,
		TrashReason,
		ShortUrl,
		AuthCode,
		ExtendId,
		VSessionId,
		PinCode,
		1 as [BatchTransactionDetailId],
		null as [SessionId],
		GETDATE() as [BackupOn],
		'Manual' as [Channel],
		null as [Comment] from Voucher with(nolock) 
		where VoucherNumber = @VoucherNumber AND ProgramId = @ProgramId

		delete from Voucher where VoucherNumber = @VoucherNumber AND ProgramId = @ProgramId
-------------


	declare @StockTable varchar(50);
	select @StockTable = VoucherStockTableName from ProgramVoucherRoute where ProgramId = @ProgramId;

	DECLARE @UpdateStockStatus nvarchar(max);
	SET @UpdateStockStatus = 'Update '+@StockTable+' set StockStatus = 0 where VoucherNumber = @VoucherNumber';
	exec SP_EXECUTESQL @UpdateStockStatus, N'@VoucherNumber varchar(100)', @VoucherNumber=@VoucherNumber;

	update [Transaction]
	set ResponseCode = '9999'
	where AccountNumber = @VoucherNumber AND ProgramCode = @ProgramCode;









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