
CREATE PROCEDURE spFetchMoveBatchData_DoBatchTransactionJob
AS
BEGIN
DECLARE @BatchName varchar(100)
Set @BatchName = 'DoBatchTransactionJob'
    select top 1 @BatchName as [Name],DATEDIFF(Second, ExecuteStartTime, GETDATE()) as Result from BatchLog with(nolock) 
	where [Status] = 8 AND BatchName = @BatchName
	order by Id desc;
END
