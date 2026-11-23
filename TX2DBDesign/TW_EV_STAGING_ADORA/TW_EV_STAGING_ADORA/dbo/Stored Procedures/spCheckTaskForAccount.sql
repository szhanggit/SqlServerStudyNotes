
CREATE PROC spCheckTaskForAccount @TaskId VARCHAR(50)
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @duplicatedCount AS INT;

        SELECT  @duplicatedCount = COUNT(*)
			FROM dbo.AccountBuffer1 a WITH(NOLOCK)
            INNER JOIN dbo.AccountBuffer2 b WITH(NOLOCK) ON a.AccountNumber = b.AccountNumber AND a.ProgramId = b.ProgramId
        WHERE   a.TaskId = @TaskId;

        IF @duplicatedCount < 1
            BEGIN
                SELECT  @duplicatedCount = COUNT(*)
					FROM dbo.AccountBuffer1 a WITH(NOLOCK)
					INNER JOIN dbo.AccountKey b WITH(NOLOCK) ON a.AccountNumber = b.AccountNumber AND a.ProgramId = b.ProgramId
                WHERE   a.TaskId = @TaskId;
            END;

        SELECT  @duplicatedCount AS DuplicatedCount;
    END;
