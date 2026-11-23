
CREATE PROCEDURE spGetTerminalEntityInfo
	@IdentityCode VARCHAR(50), 
	@ProgramId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	select top 1 SecurityKeyId,TimeOffset,MaxFailNumber from Terminal with(nolock) 
    where Status = 1 and ProgramId = @ProgramId and IdentityCode = @IdentityCode
END
