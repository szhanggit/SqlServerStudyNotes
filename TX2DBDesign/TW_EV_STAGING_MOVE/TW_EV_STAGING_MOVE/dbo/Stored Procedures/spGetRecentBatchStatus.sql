
CREATE PROCEDURE [dbo].[spGetRecentBatchStatus] @Period INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT BatchName
		,ExecuteStartTime
		,ExecuteEndTime
		,STATUS
	FROM BatchLog
	WHERE ExecuteStartTime > GETDATE() - @Period
		AND STATUS <> 8
	ORDER BY Id
END
