
CREATE PROCEDURE spFetchMoveBatchData_InsertTransactionJob
AS
BEGIN
DECLARE @BatchName varchar(100)
Set @BatchName = 'InsertTransactionJob'
    select top 1 @BatchName as [Name],DATEDIFF(Second, ExecuteStartTime, GETDATE()) as Result from BatchLog with(nolock) 
	where [Status] = 8 AND BatchName = @BatchName
	order by Id desc;
END
