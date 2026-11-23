
CREATE PROCEDURE [dbo].[spGetRecentMessageStatus] @CountNumber INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT COUNT(1)
	FROM (
		SELECT TOP (@CountNumber) MessageStatus
		FROM EmailMessage
		ORDER BY id DESC
		) t
	WHERE t.MessageStatus <> 2
		AND t.MessageStatus <> 3
	
	UNION ALL
	
	SELECT COUNT(1)
	FROM (
		SELECT TOP (@CountNumber) MessageStatus
		FROM SLMSMessage
		ORDER BY id DESC
		) t
	WHERE t.MessageStatus <> 2
		AND t.MessageStatus <> 3
END
