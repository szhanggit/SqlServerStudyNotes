CREATE PROCEDURE dbo.spCheckSyncFailOrderUAT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT N'CheckSyncFailOrderUAT' AS [Name], COUNT(1) AS Result   
		FROM dbo.[Order] WITH(NOLOCK) WHERE 
			Status = 32 AND 
			ExecutingStatus = 5 AND
			CreatedOn > DATEADD(day, -3, GETDATE()) AND
			PublishDatetime < DATEADD(MINUTE, -30, GETDATE());
END
