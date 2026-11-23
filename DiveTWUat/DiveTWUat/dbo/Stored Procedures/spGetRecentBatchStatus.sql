
CREATE PROCEDURE [dbo].[spGetRecentBatchStatus] @Period INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT BatchType
		,StartTime
		,EndTime
		,STATUS
	FROM Batch b
	WHERE StartTime > GETUTCDATE() - @Period
		AND STATUS <> 8
	ORDER BY BatchType
END
