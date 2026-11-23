
CREATE PROCEDURE dbo.spGetAccountToSyncMaxTimeByProgram
@ProgramId INT,
@DateTimeNumber BIGINT OUTPUT
AS
    SET NOCOUNT ON
	if exists(SELECT * FROM dbo.AccountToSync ats WITH(NOLOCK)  
		INNER JOIN Program p WITH(NOLOCK) ON ats.ProgramId = p.Id
		WHERE p.ExternalId = @ProgramId)
	begin
		SELECT @DateTimeNumber = MAX(ChangedUTCTimeL) FROM dbo.AccountToSync ats WITH(NOLOCK)  
		INNER JOIN Program p WITH(NOLOCK) ON ats.ProgramId = p.Id
		WHERE p.ExternalId = @ProgramId;
	end
	else
	begin
		set @DateTimeNumber = 0;
	end
