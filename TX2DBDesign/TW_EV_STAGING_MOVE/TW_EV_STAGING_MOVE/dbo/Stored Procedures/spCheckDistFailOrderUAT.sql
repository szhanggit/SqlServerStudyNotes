CREATE PROCEDURE dbo.spCheckDistFailOrderUAT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT N'CheckDistFailOrderUAT' AS [Name], COUNT(1) AS Result   
		FROM dbo.[Order] WITH(NOLOCK) WHERE 
			Status = 32 AND
			ExecutingStatus = 7 AND
			CreatedOn > DATEADD(day, -3, GETDATE()) AND 
			PublishDatetime < DATEADD(MINUTE, -30, GETDATE());
END
