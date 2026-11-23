CREATE PROCEDURE spFetchDiveSLMSNotSent
AS
BEGIN
	DECLARE @BatchName VARCHAR(100) = 'Dive_SLMSNotSent'
	DECLARE @SearchDate DATETIME = GETDATE()
	DECLARE @SearchDateFrom DATETIME = DATEADD(DAY, -7, @SearchDate)
	DECLARE @SearchDateTo DATETIME = DATEADD(DAY, -1, @SearchDate)

	SELECT @BatchName, COUNT(1) 
	FROM SLMSMessage WITH (NOLOCK)
	WHERE MessageStatus IN (1, 2)
	AND CreatedOn >= @SearchDateFrom AND CreatedOn < @SearchDateTo
END
