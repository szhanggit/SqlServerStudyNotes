
CREATE PROCEDURE dbo.spAdoraCheckingData
AS
    SET NOCOUNT ON
	DECLARE @WorkingTable TABLE (
		Id int identity not null,
		BatchType int null,
		BatchName varchar(100) null,
		ExecuteStartTime DateTime null,
		ExecutePeriod decimal(20,2) null,
		[Status] int null,
		Diff int null,
		IsGood int null
	);

	insert into @WorkingTable(BatchType, BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchAdoraBatchData 'PreAuthorizationExpireJob', 1, 1;		--PreAuthorizationExpireJob
	insert into @WorkingTable(BatchType, BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchAdoraBatchData 'ExpireAccountJob', 4, 0.25;		--ExpireAccountJob
	insert into @WorkingTable(BatchType, BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchAdoraBatchData 'CleanAccountJob', 64, 24;			--CleanAccountJob
	insert into @WorkingTable(BatchType, BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchAdoraBatchData 'ActivateAccountJob', 128, 0.02;		--ActivateAccountJob
	insert into @WorkingTable(BatchType, BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchAdoraBatchData 'TransactionGenerationJob', 256, 0.17;	--TransactionGenerationJob
	insert into @WorkingTable(BatchType, BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchAdoraBatchData 'CreateAccountJob', 512, 0.05;		--CreateAccountJob
	insert into @WorkingTable(BatchType, BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchAdoraBatchData 'DoBatchTransactionTaskJob', 1024, 0.08;	--DoBatchTransactionTaskJob
	insert into @WorkingTable(BatchType, BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchAdoraBatchData 'CreateLETransactionJob', 4096, 1;		--CreateLETransactionJob
	insert into @WorkingTable(BatchType, BatchName, ExecuteStartTime, ExecutePeriod, [Status], Diff, IsGood) exec spFetchAdoraBatchData 'ProcessOldLEJob', 16384, 1;		--ProcessOldLEJob
	select * from @WorkingTable where IsGood = 0
