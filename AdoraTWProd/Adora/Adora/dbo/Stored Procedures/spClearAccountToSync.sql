-- =============================================
-- Author:		Knight Yao
-- Create date: 2016/06/29
-- Description:	Clear AccuntToSync Table
-- =============================================
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

	delete [dbo].[AccountToSync]
	where ProgramId = @ProgramId and ChangedUTCTimeL <= @ClearUntil

END
