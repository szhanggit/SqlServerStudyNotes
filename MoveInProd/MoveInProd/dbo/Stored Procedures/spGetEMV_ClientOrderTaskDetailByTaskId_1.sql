
CREATE PROCEDURE [dbo].[spGetEMV_ClientOrderTaskDetailByTaskId] 
	@EMV_ClientOrderTaskId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT  *
	FROM [dbo].[EMV_ClientOrderTaskDetail] AS T WITH(NOLOCK)
	WHERE [ClientOrderTaskId] = @EMV_ClientOrderTaskId
END
