-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spCheckMemberExists]
	-- Add the parameters for the stored procedure here
	@OrderNumber VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT DISTINCT t.Mobile
	FROM MemberCheckTemp t
	LEFT JOIN Member m ON t.Mobile = m.Mobile
	WHERE m.Mobile IS NULL
		AND t.OrderNumber = @OrderNumber
END

