
CREATE PROCEDURE [dbo].[spGetEMV_ClientOrderLine] 
	@EMV_ClientOrderLineId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 1
		*
	FROM [dbo].[EMV_ClientOrderLine] AS T WITH(NOLOCK)
	WHERE [Id] = @EMV_ClientOrderLineId
END
