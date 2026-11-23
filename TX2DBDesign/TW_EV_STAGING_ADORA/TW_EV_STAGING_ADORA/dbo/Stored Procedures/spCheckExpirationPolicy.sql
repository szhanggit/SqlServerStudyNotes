
CREATE PROCEDURE spCheckExpirationPolicy
    @ProgramId INT
AS
BEGIN
    DECLARE @ExistsProgramId INT
    IF NOT EXISTS(SELECT 1
    FROM dbo.ExpirationPolicy
    WHERE ProgramId = @ProgramId)
BEGIN
        SELECT TOP (1)
            @ExistsProgramId = ProgramId
        FROM dbo.ExpirationPolicy
        ORDER BY ProgramId DESC
        INSERT INTO [dbo].[ExpirationPolicy]
            ([ProgramId]
            ,[ExternalId]
            ,[Type]
            ,[ValidPeriod]
            ,[IsEndOfDay])
        SELECT
            @ProgramId
    , [ExternalId]
    , [Type]
    , [ValidPeriod]
    , [IsEndOfDay]
        FROM [dbo].[ExpirationPolicy]
        WHERE ProgramId = @ExistsProgramId
    END

END
