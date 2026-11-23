

CREATE PROCEDURE [dbo].[spGetChildProductQuotationProduct_TW]
	-- Add the parameters for the stored procedure here
	@QuotationNumber varchar(50), 
	@ProductCode varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		T2.Id 
		,T11.[Name] AS BusinessModel
		,T10.Id AS BusinessModelId
		,T10.IsPrepaid  
		,T6.ProductCode
		,T5.ProductName
		,T6.ProductSubType ProductType
		,T1.ProjectName
		,CASE WHEN T6.IsMasterProduct = 1 THEN 'Master'
			WHEN T6.IsMasterProduct = 2 THEN 'Child'
			ELSE 'General' END AS [MultipleSelectionType]
		,T1.QuotationNumber
		,T1.Id AS QuotationId
		,T1.ValidFrom
		,T1.ValidTo
		,T1.Sales
		,T9.[Name] AS ClientName
		,SUBSTRING(T6.ProductCode,1,3) AS ProductCodePrefix
		,T13.Name AS [ExpiryScheme]
		,CASE 
			WHEN T6.ProductType = 1 THEN CAST(ISNULL(T7.FaceValueWithTax, 0) / 100.00 AS NUMERIC(15, 2))
			WHEN T6.ProductType = 2 THEN
				CASE
					WHEN T6.ProductSubType = 4 THEN 0
					ELSE CAST(ISNULL(T8.FaceValueWithTax, 0) / 100.00 AS NUMERIC(15, 2))
				END
			ELSE 0 
		 END AS [MarketPrice]
		,CASE 
			WHEN T6.ProductType = 1 THEN CASE T10.IsPrepaid WHEN 1 THEN ISNULL(T7.SellingPricePrepaidWithTax,0) ELSE ISNULL(T7.SellingPricePostpaidWithTax,0) END
			WHEN T6.ProductType = 2 THEN
				CASE
					WHEN T6.ProductSubType = 4 THEN CONVERT(DECIMAL(10,6), ISNULL(ppdfv.DefaultSellingPrice,0)) / 100
					ELSE ISNULL(T8.SellingPricePrepaidWithTax,0)
				END
			ELSE 0 
		 END AS DefaultSellingPrice
		,CASE 
			WHEN T6.ProductType = 1 THEN ISNULL(T7.Cost,0)
			WHEN T6.ProductType = 2 THEN
				CASE
					WHEN T6.ProductSubType = 4 THEN CONVERT(DECIMAL(10,6), ISNULL(ppdfv.DefaultProductCost,0)) / 100
					ELSE CAST((ISNULL(T8.FaceValueWithTax,0) * ISNULL(T8.MerchantFeeWithTax,0))/10000.0000 AS NUMERIC(15,4))
				END  
			ELSE 0 
		 END AS [Cost]
		,ISNULL(T2.MaxIssueVoucherNumber,1) AS MaxIssueVoucherNumber
		,NULL ProductApprovedSoldPrice
		,CASE
			WHEN t6.ProductType = 1 THEN
				CASE 
					WHEN T15.ProductType = 2 AND (T15.ProductSubType = 6 OR T15.ProductSubType = 8)
						THEN CONVERT(numeric(15,4), T7.FaceValue * masterSP.ValueBasedSoldPriceWithTax / masterPPVB.FaceValueWithTax)
					ELSE CONVERT(numeric(15,4),masterSP.SoldPriceWithTax / T7.Balance)
				END
			WHEN t6.ProductType = 2 THEN
				CASE 
					WHEN T15.ProductType = 2 AND (T15.ProductSubType = 6 OR T15.ProductSubType = 8)
						THEN CONVERT(numeric(15,4), T8.FaceValue * masterSP.ValueBasedSoldPriceWithTax / masterPPVB.FaceValueWithTax)
					ELSE masterSP.SoldPriceWithTax
				END
			ELSE NULL
        END ProductSoldPrice
	FROM [dbo].[ClientQuotation] AS T1 WITH (NOLOCK)
	JOIN [dbo].[ClientQuotationProduct] AS T2 WITH (NOLOCK) ON T1.Id = T2.ClientQuotationId
	JOIN [dbo].[ClientQuotationProductCombo] AS T3 WITH (NOLOCK) ON T2.Id = T3.ClientQuotationProductId
	JOIN [dbo].[ProductComboSet] AS T4 WITH (NOLOCK) ON T3.ProductComboSetId = T4.Id
	JOIN [dbo].[ProductVersion] AS T5 WITH (NOLOCK) ON T4.ChildProductVersionId = T5.Id
	JOIN [dbo].[Product] AS T6 WITH (NOLOCK) ON T5.ProductId = T6.Id
	LEFT JOIN [dbo].[ProductPricingProductBased] AS T7 WITH (NOLOCK) ON T5.ProductPricingProductBasedId = T7.Id
	LEFT JOIN [dbo].[ProductPricingValueBased] AS T8 WITH (NOLOCK) ON T5.ProductPricingValueBasedId = T8.Id
	LEFT JOIN [dbo].ProductPricingDynamicFaceValue AS ppdfv WITH (NOLOCK) ON ppdfv.ProductVersionId = T5.Id
	JOIN [dbo].[Client] AS T9 WITH (NOLOCK) ON  T1.ClientId = T9.Id
	JOIN [dbo].[BusinessModel] AS T10 WITH (NOLOCK) ON T1.BusinessModelId = T10.Id
	JOIN [dbo].[Dictionary] AS T11 WITH (NOLOCK) ON T10.DisplayNameId = T11.Id
	JOIN [dbo].[ExpirationPolicy] AS T12 WITH (NOLOCK) ON T2.ExpirySchemeId = T12.Id
	JOIN [dbo].[Dictionary] AS T13 WITH (NOLOCK) ON T12.DisplayNameId = T13.Id
	JOIN [dbo].[ProductVersion] AS T14 WITH(NOLOCK) ON T2.ProductVersionId = T14.Id
	JOIN [dbo].[Product] AS T15 WITH(NOLOCK) ON T14.ProductId = T15.Id
	LEFT JOIN dbo.ProductPricingProductBased masterPPPB ON masterPPPB.Id = T14.ProductPricingProductBasedId
	LEFT JOIN dbo.ProductPricingValueBased masterPPVB ON masterPPVB.Id = T14.ProductPricingValueBasedId
	LEFT JOIN dbo.ClientQuotationProductSoldPrice masterSP ON masterSP.ClientQuotationProductId = T2.Id AND masterSP.[Status] = 1
	WHERE T1.QuotationNumber = @QuotationNumber
	AND T15.ProductCode = @ProductCode
END
