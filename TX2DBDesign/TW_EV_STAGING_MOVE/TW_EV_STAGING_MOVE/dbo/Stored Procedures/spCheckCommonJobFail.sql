CREATE PROCEDURE dbo.spCheckCommonJobFail
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @joblist VARCHAR(200) = 'SendVoucherRetryJob'; --need check jobs

	DECLARE @jobName NVARCHAR(50);
	DECLARE @start INT = 1;
	DECLARE @end INT = 1;
	DECLARE @lastExecuteTime DATETIME;
	DECLARE @last2ExecuteTime DATETIME;

	DECLARE @message VARCHAR(100) = '';
	DECLARE @jobCount INT = 0;

	WHILE @end > 0
	BEGIN
		SET @end = CHARINDEX(',',@joblist,@start);
		IF @end > 0
		BEGIN
			SET @jobName = SUBSTRING(@joblist, @start, @end - @start)	
			SET @start = @end + 1;
		END
		ELSE
		BEGIN
			SET @jobName = SUBSTRING(@joblist, @start, LEN(@joblist) - @start + 1)
		END

		SET @lastExecuteTime = NULL;
		SELECT TOP (1) @lastExecuteTime = ExecuteStartTime FROM dbo.BatchLog WITH(NOLOCK) WHERE BatchName = @jobName ORDER BY ID DESC
		
		IF @lastExecuteTime IS NULL OR DATEDIFF(HOUR, @lastExecuteTime, GETDATE()) > 24
		BEGIN
			SET @message = @message + @jobName + ','
			SET @jobCount += 1;
		END
		ELSE
		BEGIN
			SET @last2ExecuteTime = NULL;
			SELECT TOP (1) @last2ExecuteTime = ExecuteStartTime FROM dbo.BatchLog WITH(NOLOCK) 
				WHERE BatchName = @jobName AND ExecuteStartTime < @lastExecuteTime ORDER BY ID DESC

			IF @last2ExecuteTime IS NOT NULL 
				AND (DATEDIFF(MINUTE, @lastExecuteTime, GETDATE()) > 3 * DATEDIFF(MINUTE, @last2ExecuteTime, @lastExecuteTime))
				AND DATEDIFF(MINUTE, @lastExecuteTime, GETDATE()) > 20
			BEGIN
				--由最近两次执行时间算出间隔 如果超过3个间隔都未执行 认为job挂了 为了防止上版导致误报还需大于20分钟
				SET @message = @message + @jobName + ','
				SET @jobCount += 1;
			END
		END
	END

	IF @jobCount > 0
	BEGIN
		DECLARE @dbprefix VARCHAR(2) = (Select LEFT(name, 2) From sys.SysDataBases Where DbId=(Select Dbid From sys.SysProcesses Where Spid = @@spid))
		SET @message = @dbprefix + ' PROD Job ' + @message + ' are not running';
	END
	SELECT N'CheckCommonJobFail' AS [Name], @jobCount Result, @message [Message];
END