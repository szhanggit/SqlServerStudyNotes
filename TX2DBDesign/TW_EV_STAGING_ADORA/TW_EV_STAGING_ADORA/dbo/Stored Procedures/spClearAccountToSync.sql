CREATE PROCEDURE spClearAccountToSync
	@ClearUntil bigint
	,@ProgramCode varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @ProgramId int
	select @ProgramId = Id from Program where IdentityCode = @ProgramCode

	WHILE(1=1)
	BEGIN
		delete top (3000) [dbo].[AccountToSync]
		where ProgramId = @ProgramId and ChangedUTCTimeL <= @ClearUntil
		if @@ROWCOUNT = 0
		BEGIN
			BREAK;
		END
	END
END