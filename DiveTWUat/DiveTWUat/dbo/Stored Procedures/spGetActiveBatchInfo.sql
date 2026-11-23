
CREATE PROCEDURE [dbo].[spGetActiveBatchInfo]
AS
BEGIN
	DECLARE @CurrentDateTime DATETIME = GETUTCDATE()

	SELECT * 
	INTO #TEMP
	FROM Monitor_BatchInfo
	WHERE Status = 1 AND
	(LastAlertTime IS NULL OR DATEDIFF(MINUTE, LastAlertTime, GETUTCDATE()) > 60)

	UPDATE Monitor_BatchInfo SET LastCheckTime = @CurrentDateTime
	FROM #TEMP T WHERE Monitor_BatchInfo.Id = T.Id

	SELECT * FROM #TEMP
END

