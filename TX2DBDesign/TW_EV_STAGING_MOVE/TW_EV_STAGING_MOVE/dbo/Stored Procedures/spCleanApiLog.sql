
CREATE PROCEDURE [dbo].[spCleanApiLog] 
AS
BEGIN
DECLARE @Month varchar(2);
DECLARE @TableName varchar(50);
DECLARE @sql nvarchar(max);

select @Month=DATEPART(m,DATEADD(M,-5,GETDATE()))
SET @TableName = 'APILog_'+@Month

set @sql =
'IF EXISTS (SELECT top 1 * FROM '+@TableName+' with(nolock))
Begin

DECLARE @cnt INT = 3500
DECLARE @step INT = 3500
DECLARE @start bigint
DECLARE @end bigint
DECLARE @step_start bigint
DECLARE @step_end bigint

SELECT @start = MIN(Id),@end= Max(Id) FROM dbo.'+@TableName+' WITH(NOLOCK)

SELECT @step_start = @start,
	   @step_end = @start + @step

WHILE (@step_end <= @end)  
BEGIN
 INSERT INTO dbo.APILog WITH (TABLOCK)
 (     [Id]
      ,[ConsumerCode]
      ,[OperationCode]
      ,[RequestId]
      ,[CreatedOn]
      ,[ResponseCode]
      ,[Comment]
      ,[ResponsedOn]
      ,[RequestMessage]
      ,[ResponseMessage])
SELECT [Id]
      ,[ConsumerCode]
      ,[OperationCode]
      ,[RequestId]
      ,[CreatedOn]
      ,[ResponseCode]
      ,[Comment]
      ,[ResponsedOn]
      ,[RequestMessage]
      ,[ResponseMessage]
 FROM dbo.'+@TableName+' WITH (NOLOCK)
 WHERE ID BETWEEN @step_start AND @step_end
 
 DELETE FROM dbo.'+@TableName+'
 WHERE ID BETWEEN @step_start AND @step_end

 IF(@step_end = @end)
   RETURN;

 SELECT @step_start = @step_end+1, @step_end = @step_end + @step

 IF (@step_end > @end)
   SET @step_end = @end

END
Truncate table '+@TableName+'
End
'
exec (@sql)
END
