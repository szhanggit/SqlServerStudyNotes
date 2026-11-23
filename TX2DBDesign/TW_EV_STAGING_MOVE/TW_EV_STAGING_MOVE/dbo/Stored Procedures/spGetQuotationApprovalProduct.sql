-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetQuotationApprovalProduct] 
	-- Add the parameters for the stored procedure here
	@ProductCode varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT P.ProductCode
		,SUBSTRING(P.ProductCode,0,3) AS ProductCodePrefix
		,ISNULL(PPPB.FaceValue,0) AS [MarketPrice]
		,ISNULL(PPPB.SellingPricePrepaid,0) AS [DefaultSellingPricePrepaid]
		,ISNULL(PPPB.SellingPricePostpaid,0) AS [DefaultSellingPricePostpaid]
	FROM [dbo].[ProductVersion] AS PV 
		INNER JOIN [dbo].[Product] AS P WITH (NOLOCK) ON PV.ProductId = P.Id
		LEFT JOIN [dbo].[ProductPricingProductBased] AS PPPB WITH (NOLOCK) ON PV.ProductPricingProductBasedId = PPPB.Id
	WHERE P.ProductCode = @ProductCode
		AND PV.IsCurrentVersion = 1
END