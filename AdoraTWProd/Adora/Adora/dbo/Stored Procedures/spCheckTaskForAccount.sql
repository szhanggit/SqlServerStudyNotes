
CREATE PROCEDURE spCheckTaskForAccount @TaskId VARCHAR(50)
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @duplicatedCount AS INT;
        SELECT  @duplicatedCount = COUNT(*)
        FROM    AccountBuffer1 a
                INNER JOIN AccountBuffer2 b ON a.AccountNumber = b.AccountNumber
                                               AND a.ProgramId = b.ProgramId
        WHERE   a.TaskId = @TaskId;
        IF @duplicatedCount < 1
            BEGIN

                SELECT  @duplicatedCount = COUNT(*)
                FROM    AccountBuffer1 a
                        INNER JOIN AccountKey b ON a.AccountNumber = b.AccountNumber
                                                   AND a.ProgramId = b.ProgramId
                WHERE   a.TaskId = @TaskId;
            END;

        SELECT  @duplicatedCount AS DuplicatedCount;
    END;


