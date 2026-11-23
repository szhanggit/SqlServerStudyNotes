
CREATE PROCEDURE [dbo].[spGetTasksByThreshold] @Threshold INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @messageNumber INT = 0
	DECLARE @taskId INT = 0
	DECLARE @totalMessageCount INT = 0
	DECLARE @idTable TABLE (Id INT)

	DECLARE taskCursor CURSOR
	FOR
	SELECT MessageNumber
		,Id
	FROM dbo.Task with(nolock)
	WHERE TaskStatus = 1
		AND isnull(IsBulk,0) = 0
		AND ScheduledDateTime < GETUTCDATE()
		AND CreatedOn < DATEADD(MINUTE, -1, GETUTCDATE())

	OPEN taskCursor

	FETCH NEXT
	FROM taskCursor
	INTO @messageNumber
		,@taskId

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @totalMessageCount = @totalMessageCount + @messageNumber

		INSERT INTO @idTable
		VALUES (@taskId)

		IF @totalMessageCount > @Threshold
			BREAK

		FETCH NEXT
		FROM taskCursor
		INTO @messageNumber
			,@taskId
	END

	SELECT t1.*
	FROM Task t1 with(nolock)
	JOIN @idTable t2 ON t1.Id = t2.Id

	CLOSE taskCursor

	DEALLOCATE taskCursor
END
