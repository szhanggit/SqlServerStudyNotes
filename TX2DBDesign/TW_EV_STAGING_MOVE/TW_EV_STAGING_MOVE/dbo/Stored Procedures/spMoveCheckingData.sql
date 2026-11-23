
CREATE PROCEDURE dbo.spMoveCheckingData
AS
    SET NOCOUNT ON
	DECLARE @WorkingTable TABLE (
		Id int identity not null,
		BatchName varchar(100) null,
		ExecuteStartTime DateTime null,
		ExecutePeriod decimal(20,2) null,
		[Status] int null,
		Diff int null,
		IsGood int null
	);

	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'ArchiveBatchLogJob', 24;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'CalculateInvoiceJob', 24;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'CalculateReimbursementJob', 24;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'CompareTransactionCountJob', 24;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'InsertTransactionJob',  0.5;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'SyncAuthJob', 0.08;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'SyncDistJob', 24;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'SyncTransactionJob', 0.08;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'PublishOrderJob', 12;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'DoBatchTransactionJob', 0.08;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'ProductStatJob', 24;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'ClearAccountToSyncJob', 24;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'ProcessTaskJob', 0.08;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'AutoCalculateReimbursementJob', 24;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'SyncTransactionCutLineJob', 24;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'DoUpdateBatchTransactionJob', 0.08;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'OrderTrustAccountReport', 1;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'DailyTrustAccountReport', 24;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'AutoTrashVouchersJob', 24;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'AutoSendDistributionFailMailJob', 24;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'TrustAccountJob', 0.08;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'ArchiveTransactionJob', 24;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'ArchivePublishedBufferJob', 24;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'ProductEmailSLMSTemplateApplyOrderJob', 0.08;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'AdoraIsEqualToMoveJob', 0.08;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'AutoGenerateOrderFileJob',	0.08;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'AutoReleaseVoucherJob', 0.25;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'ExportBillingBoxPartOneInfoJob', 24;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'ExportBillingBoxPartTwoInfoJob', 1;
	insert into @WorkingTable(BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchMoveBatchData 'CreditLimitJob', 0.25;
	select * from @WorkingTable where IsGood=0;

