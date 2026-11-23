
CREATE PROCEDURE [dbo].[spGetBulkTasksList]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT *
	FROM dbo.Task with(nolock)
	WHERE TaskStatus = 1
		AND isnull(IsBulk,0) = 1
		AND ScheduledDateTime < GETUTCDATE()
		AND CreatedOn < DATEADD(MINUTE, -1, GETUTCDATE())
		
END
