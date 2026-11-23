
CREATE PROCEDURE [dbo].[spCountMessagesNotProcessed] @HoursPeriod INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT COUNT(1)
	FROM EmailMessage
	WHERE DATEDIFF(HOUR, CreatedOn, GETDATE()) > @HoursPeriod
		AND MessageStatus = 1
	
	UNION ALL
	
	SELECT COUNT(1)
	FROM SLMSMessage
	WHERE DATEDIFF(HOUR, CreatedOn, GETDATE()) > @HoursPeriod
		AND MessageStatus = 1
END
