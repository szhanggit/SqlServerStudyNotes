
CREATE PROCEDURE [dbo].[spGetLastBatchStatus] @Period INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT BatchName
		,ExecuteStartTime
		,ExecuteEndTime
		,STATUS
	FROM BatchLog b
	JOIN (
		SELECT Max(id) AS Id
		FROM BatchLog
		WHERE ExecuteStartTime > GETDATE() - @Period
		GROUP BY BatchName
		) t ON b.Id = t.Id
	ORDER BY b.Id
END
