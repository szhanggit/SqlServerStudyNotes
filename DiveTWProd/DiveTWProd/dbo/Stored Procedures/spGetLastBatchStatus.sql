
CREATE PROCEDURE [dbo].[spGetLastBatchStatus] @Period INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT BatchType
		,StartTime
		,EndTime
		,STATUS
	FROM Batch b
	INNER JOIN (
		SELECT Max(id) AS Id
		FROM Batch
		WHERE StartTime > GETUTCDATE() - @Period
		GROUP BY BatchType
		) t ON b.Id = t.Id
	ORDER BY BatchType
END
