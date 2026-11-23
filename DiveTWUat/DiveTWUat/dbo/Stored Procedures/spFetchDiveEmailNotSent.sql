
CREATE PROCEDURE spFetchDiveEmailNotSent
AS
BEGIN
	DECLARE @BatchName VARCHAR(100) = 'Dive_EmailNotSent'
	DECLARE @SearchDate DATETIME = GETDATE()
	DECLARE @SearchDateFrom DATETIME = DATEADD(DAY, -7, @SearchDate)
	DECLARE @SearchDateTo DATETIME = DATEADD(DAY, -1, @SearchDate)

	SELECT @BatchName, COUNT(1) 
	FROM EmailMessage WITH (NOLOCK)
	WHERE MessageStatus IN (1, 2)
	AND CreatedOn >= @SearchDateFrom AND CreatedOn < @SearchDateTo
END
