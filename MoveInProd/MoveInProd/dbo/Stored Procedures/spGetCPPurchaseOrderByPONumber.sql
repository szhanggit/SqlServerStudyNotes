-- =============================================
-- Author:		Zhu Jianhua
-- Create date: 2017-04-13
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetCPPurchaseOrderByPONumber]
	-- Add the parameters for the stored procedure here
	@PONumber VARCHAR(50),
	@ClientQuotationProductId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [Id]
      ,[PONumber]
      ,[ClientQuotationProductId]
      ,[TotalQuantity]
      ,[AvailableQuantity]
      ,[CreatedOn]
      ,[SoldPrice]
	FROM [dbo].[EXT_TW_CPPurchaseOrder]
	WHERE [PONumber] = @PONumber AND ClientQuotationProductId = @ClientQuotationProductId

END

