-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetProductByProgramCode] 
	-- Add the parameters for the stored procedure here
	@ProgramCode VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		T1.ProductCode
		,T1.ProductName
		,T1.ExternalProductCode 
	FROM [dbo].[Product] AS T1
	INNER JOIN [dbo].[Program] AS T2 ON T1.ProgramId = T2.Id
	WHERE T2.IdentityCode = @ProgramCode
	AND T1.[Status] = 1

END

