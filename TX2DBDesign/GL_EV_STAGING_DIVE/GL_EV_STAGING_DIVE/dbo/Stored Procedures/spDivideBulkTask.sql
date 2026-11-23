
CREATE PROCEDURE [dbo].[spDivideBulkTask]
@Taskid bigint,
@Numberofperpiece int
AS
BEGIN
    SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION
		DECLARE @TotalMessageNumber int;
		DECLARE @MessageType int;
		DECLARE @Pages int;
		DECLARE @PageIndex int;
		DECLARE @startNum int;
		DECLARE @endNum int;
		DECLARE @MessageNumber int;

		SET @PageIndex = 1;
		SELECT @TotalMessageNumber = t.MessageNumber, @MessageType = t.MessageType from dbo.Task t with(NOLOCK) WHERE t.Id = @Taskid;

		IF(@TotalMessageNumber % @Numberofperpiece > 0)
		BEGIN
			SET @Pages = @TotalMessageNumber / @Numberofperpiece + 1;
		END
		ELSE
		BEGIN
			SET @Pages = @TotalMessageNumber / @Numberofperpiece;
		END
		
		WHILE @PageIndex <= @Pages
		BEGIN
		    SET @startNum = (@PageIndex -1) * @Numberofperpiece;
			SET @endNum = @PageIndex * @Numberofperpiece;

			if(@PageIndex = @Pages)
			BEGIN
				SET @MessageNumber = @TotalMessageNumber - (@Pages -1) * @Numberofperpiece;
			END
			ELSE
			BEGIN
				SET @MessageNumber = @Numberofperpiece;
			END

			INSERT INTO dbo.BulkDividedTasks(TaskId,TaskStatus,MessageNumber,CreatedOn,ProcessedOn,TriedCount) VALUES(@Taskid, 0, @MessageNumber, getdate(), NULL, 0);

			IF (@MessageType = 2)
			BEGIN
				INSERT INTO dbo.BulkDividedTasksMessages(BulkDividedTasksId,MessageId,MessageType)
				SELECT SCOPE_IDENTITY(), b.Id, @MessageType FROM (SELECT s.Id, ROW_NUMBER() OVER(Order by s.Id ) AS RowId from dbo.SLMSMessage s with(NOLOCK) WHERE s.TaskId = @Taskid) as b where RowId > @startNum and RowId <= @endNum
			END
			
			SET @PageIndex = @PageIndex + 1;
		END
		
	COMMIT TRANSACTION
	
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS Message;
		ROLLBACK TRANSACTION;
	END CATCH;
END;
