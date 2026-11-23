
CREATE PROCEDURE [dbo].[spGetRealTimeTXJobAlertInfoV2]
	@cqpcTable Alert_Input Readonly
AS
BEGIN
	SET NOCOUNT ON;

	select re.Id as AlertId, re.[Name] as AlertName, re.Result, re.Mark, re.LastUpdateTime 
	from SupportDashboardLookup re with(nolock)
	inner join @cqpcTable ct on re.Id = ct.AlertId

END
