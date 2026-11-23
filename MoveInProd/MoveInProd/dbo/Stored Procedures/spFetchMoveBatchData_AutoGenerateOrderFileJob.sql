
CREATE PROCEDURE spFetchMoveBatchData_AutoGenerateOrderFileJob
AS
BEGIN
DECLARE @BatchName varchar(100)
Set @BatchName = 'AutoGenerateOrderFileJob'
    select top 1 @BatchName as [Name],DATEDIFF(Second, ExecuteStartTime, GETDATE()) as Result from BatchLog with(nolock) 
	where [Status] = 8 AND BatchName = @BatchName
	order by Id desc;
END
