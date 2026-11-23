
CREATE PROCEDURE [dbo].[spGetRealTimeTXJobAlertInfo]
	@cqpcTable Alert_Input Readonly
AS
BEGIN
	SET NOCOUNT ON;

	select re.Id as AlertId, re.[Name] as AlertName, re.Result, re.Mark, re.LastUpdateTime 
	from TX_KGB_Result re with(nolock)
	inner join @cqpcTable ct on re.Id = ct.AlertId

END
