
Create PROCEDURE [dbo].[spGetGhostForBillingBox] 
	-- Add the parameters for the stored procedure here
	@DATETIME DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @DateInt INT
	DECLARE @BeginDate DATETIME
	DECLARE @EndDate DATETIME

	SET @DateInt = CONVERT(INT,CONVERT(VARCHAR(100), @DATETIME, 112))
	SET @BeginDate = DATEADD(D,DATEDIFF(D,0,@DATETIME),0)
	SET @EndDate = DATEADD(day,1,@BeginDate)

	SELECT t1.Id
	FROM dbo.[Transaction] t1 WITH(NOLOCK)
	inner join GhostVoucherTransaction gvt with(nolock) on t1.AccountNumber = gvt.AccountNumber AND t1.TranCode = gvt.TranCode
	  JOIN dbo.Dictionary t2 WITH(NOLOCK) ON t1.TranType = t2.Name AND t2.Category = 'TransactionType'
	  LEFT JOIN dbo.Merchant t3 WITH(NOLOCK) ON t1.MerchantId = t3.Id
	  LEFT JOIN dbo.Shop t4 WITH(NOLOCK) ON t1.ShopId = t4.Id
	  LEFT JOIN dbo.Product t5 WITH(NOLOCK) ON t1.ProductId = t5.Id
	  LEFT JOIN dbo.[Order] t6 WITH(NOLOCK) ON t1.OrderId = t6.Id
	  LEFT JOIN dbo.OrderLine t7 WITH(NOLOCK) ON t7.OrderId = t6.Id AND t1.ClientQuotationProductId = t7.ClientQuotationProductId
	  LEFT JOIN dbo.ClientQuotationProduct t8 WITH(NOLOCK) ON t1.ClientQuotationProductId = t8.Id
	  LEFT JOIN dbo.Voucher t9 WITH(NOLOCK) ON t1.AccountNumber = t9.VoucherNumber
	  INNER JOIN dbo.Program t10 WITH(NOLOCK) ON t1.ProgramCode = t10.IdentityCode AND t9.ProgramId = t10.Id
	  LEFT JOIN dbo.OrderBeneficiaryInfo t11 WITH(NOLOCK) ON t9.BeneficiaryInfoId = t11.Id
	  LEFT JOIN [dbo].[ProductVersion] t12 WITH(NOLOCK) ON t8.ProductVersionId = t12.Id
	  LEFT JOIN [dbo].[ProductPricingProductBased] T13 WITH(NOLOCK) ON T12.ProductPricingProductBasedId = T13.Id
	  LEFT JOIN [dbo].[ProductPricingValueBased] T14 WITH(NOLOCK) ON T12.ProductPricingValueBasedId = T14.Id 
	  LEFT JOIN [dbo].ProductPricingDynamicFaceValue AS T17 WITH (NOLOCK) ON T17.ProductVersionId = t12.Id
	  LEFT JOIN [dbo].[ClientQuotationProductSoldPrice] AS t15 ON t8.Id = t15.[ClientQuotationProductId]
	  															AND t15.ValidityFrom <= t11.ActiveDate
																AND t15.ValidityEnd >= t11.ActiveDate
																AND T15.Status = 2
	  LEFT JOIN [dbo].[ReimbursementScheme] AS T16 ON T16.Id= T1.[ReimbursementSchemeId]
																AND T16.TransactionTypeId = t2.Id
	WHERE t1.TranLocalDate = @DateInt
		AND T1.ResponseCode = '0000'

END
