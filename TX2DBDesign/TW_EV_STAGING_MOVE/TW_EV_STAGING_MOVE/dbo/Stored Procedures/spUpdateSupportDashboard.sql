

CREATE PROCEDURE [dbo].[spUpdateSupportDashboard]
	@inputTable Monitor_Execution_Output Readonly
AS
BEGIN
	SET NOCOUNT ON;
	
	update sdl
	set sdl.Result = iTable.Result, sdl.LastUpdateTime = getdate()
	from SupportDashboardLookup sdl with(nolock)
	inner join @inputTable iTable on sdl.[Name] = iTable.SP

END
