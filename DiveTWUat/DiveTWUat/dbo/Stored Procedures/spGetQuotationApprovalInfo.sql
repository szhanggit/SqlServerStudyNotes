-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetQuotationApprovalInfo] 
	-- Add the parameters for the stored procedure here
	@QuotationNumber varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT BMD.Name AS BusinessModel
		,BM.Id AS BusinessModelId
		,BM.IsPrepaid  
		,P.ProductCode
		,PV.ProductName
		,CQ.ProjectName
		,CQ.QuotationNumber
		,CQ.Id AS QuotationId
		,CQ.ValidFrom
		,CQ.ValidTo
		,CQ.Sales
		,C.Name AS ClientName
		,SUBSTRING(P.ProductCode,1,3) AS ProductCodePrefix
		,EPD.Name AS [ExpiryScheme]
		,CAST(ISNULL(PPPB.FaceValue, 0) / 100.00 AS NUMERIC(15, 2)) AS [MarketPrice]
		,CASE BM.IsPrepaid WHEN 1 THEN ISNULL(PPPB.SellingPricePrepaid,0) 
		 ELSE ISNULL(PPPB.SellingPricePostpaid,0)  END [DefaultSellingPrice]
		,ISNULL(PPPB.Cost,0) AS Cost
		,CQP.SoldPrice AS ProductSoldPrice
		,CQP.SoldPriceWithTax AS ProductSoldPriceWithTax
		,ISNULL(CQP.MaxIssueVoucherNumber,1) AS MaxIssueVoucherNumber
		,SFD.Name AS [ServiceFee]
		,SFT.[TranType]   
		,CQPSFT.SoldPrice AS FeeSoldPrice
		,CQPSFT.SoldPriceWithTax AS FeeSoldPriceWithTax
	FROM [dbo].[ClientQuotationProduct] AS CQP WITH (NOLOCK)
		INNER JOIN [dbo].[ClientQuotation] AS CQ WITH (NOLOCK) ON CQP.ClientQuotationId = CQ.Id
		INNER JOIN [dbo].[ProductVersion] AS PV WITH (NOLOCK) ON CQP.ProductVersionId = PV.Id
		INNER JOIN [dbo].[Product] AS P WITH (NOLOCK) ON PV.ProductId = P.Id
		INNER JOIN [dbo].[Client] AS C WITH (NOLOCK) ON  CQ.ClientId = C.Id
		INNER JOIN [dbo].[BusinessModel] AS BM WITH (NOLOCK) ON CQ.BusinessModelId = BM.Id
		INNER JOIN [dbo].[Dictionary] AS BMD WITH (NOLOCK) ON BM.DisplayNameId = BMD.Id
		LEFT JOIN [dbo].[ProductPricingProductBased] AS PPPB WITH (NOLOCK) ON PV.ProductPricingProductBasedId = PPPB.Id
		INNER JOIN [dbo].[ExpirationPolicy] AS EP WITH (NOLOCK) ON CQP.ExpirySchemeId = EP.Id
		INNER JOIN [dbo].[Dictionary] AS EPD WITH (NOLOCK) ON EP.DisplayNameId = EPD.Id
		LEFT JOIN  [dbo].[ClientQuotationProductServiceFeeTriggerTime] AS CQPSFT WITH (NOLOCK) ON CQPSFT.ClientQuotationProductId = CQP.Id
		LEFT JOIN [dbo].[ServiceFeeTriggerTime] AS SFT WITH (NOLOCK) ON CQPSFT.ServiceFeeTriggerTimeId = SFT.Id
		LEFT JOIN [dbo].[ServiceFee] AS SF WITH (NOLOCK) ON SFT.ServiceFeeId = SF.Id
		LEFT JOIN [dbo].[Dictionary] AS SFD WITH (NOLOCK) ON SF.ServiceFeeNameId = SFD.Id
	WHERE CQ.QuotationNumber = @QuotationNumber
		AND (CQP.[Status] < 32 OR (CQP.[Status] = 32 AND CQP.NewSoldPrice IS NOT NULL)) --32:Approval

END
