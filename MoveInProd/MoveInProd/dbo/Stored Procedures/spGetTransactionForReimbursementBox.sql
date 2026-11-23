-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spGetTransactionForReimbursementBox 
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

	SELECT t1.Id,
		t1.ProgramCode,
		t1.ShopCode,		
		t1.TranType,
		t2.DisplayName AS TranTypeDisplayName,
		t1.TranLocalDate,
		REPLACE(REPLACE(REPLACE(CONVERT(varchar, ISNULL(t1.TranLocalDateTime,''), 120),'-',''),':',''),' ','') AS [TranLocalDateTime],
		t1.SettleDate,
		REPLACE(REPLACE(REPLACE(CONVERT(varchar, t1.TranRealDateTime, 120),'-',''),':',''),' ','') AS [TranRealDateTime],
		t3.Id AS [MerchantId],
		t3.Name AS [MerchantName],
		t4.id AS [ShopId],
		t4.Name AS [ShopName],
		t5.Id AS [ProductId],
		--t5.ProductName,
		IIF(t11.Id IS NULL, t5.ProductName, REPLACE(t5.ProductName, '{FV}', FORMAT(ISNULL(t11.FaceValueWithTax, 0) / 100.0,'0.##'))) ProductName,
		t5.ProductCode,
		CASE
			WHEN t5.ProductType = 1 THEN ISNULL(t15.SoldPriceWithTax, 0.0)
			WHEN t5.ProductType = 2 THEN
				CASE
					WHEN t5.ProductSubType = 4 THEN ISNULL(t11.SoldPriceWithTax,0.0)
					ELSE ISNULL(t15.ValueBasedSoldPriceWithTax,0.0)
				END
			ELSE 0
		END AS [SoldPriceWithTax],
		CASE
			WHEN t5.ProductType = 1 THEN ISNULL(t15.SoldPriceWithoutTax, 0.0)
			WHEN t5.ProductType = 2 THEN
				CASE
					WHEN t5.ProductSubType = 4 THEN ISNULL(t11.SoldPrice,0.0)
					ELSE ISNULL(t15.ValueBasedSoldPriceWithoutTax,0.0)
				END
			ELSE 0
		END AS [SoldPriceWithoutTax],
		t8.ClientQuotationId AS [QuotationId],
		t6.Id AS [OrderId],
		t6.OrderName,
		t11.ClientOrderNumber,
		t1.ServiceFee,
		t1.Rsv1,
		--t1.Rsv2,
		'' AS Rsv2,
		--t1.Rsv3,
		'' AS Rsv3,
		t9.VoucherNumber,
		t9.[GUID] AS [VoucherGuid],
		t11.Email,
		t11.Mobile,
		t11.Memo,
		t1.MerchantCode,
		t1.TranAmount,
		t1.TranCode,
		t1.TranCodeRef,
		t1.ReimbursementValue,
		t5.ProductType,
		--CASE 
		--	WHEN t5.ProductType = 1 AND t5.ProductSubType = 1 THEN ISNULL(t16.[Value],0)
		--	WHEN t5.ProductType = 1 AND t5.ProductSubType = 3 THEN ISNULL(t16.[Value],0)
		--	ELSE 0.0
		--END AS [Cost],
		CASE
			WHEN t5.ProductType = 1 THEN ISNULL(t16.[Value],0)
			WHEN t5.ProductType = 2 THEN
				CASE
					WHEN t5.ProductSubType = 4 THEN T17.DefaultProductCost
					ELSE T14.MerchantFee
				END
			ELSE 0.0
		END AS [Cost],
		CASE
			WHEN t5.ProductType = 1 THEN ISNULL(T13.FaceValue, 0)
			WHEN t5.ProductType = 2 THEN
				CASE
					WHEN t5.ProductSubType = 4 THEN ISNULL(t11.FaceValue, 0)
					ELSE ISNULL(T14.FaceValue, 0)
				END
			ELSE 0 
		END AS [FaceValue],
		CASE
			WHEN t5.ProductType = 1 THEN 0.0
			WHEN t5.ProductType = 2 THEN ISNULL(t16.Value, 0.0)
			ELSE 0
		END AS [Percentage],
		t5.ExternalProductCode,
		T1.TerminalSSN,
		T1.[BusinessDay],
		t1.BalanceAvailable,
		t13.Balance,
		t1.Channel,
		t1.[Status],
		CASE
			WHEN t5.ProductTag = 0 THEN '000' 
			WHEN t5.ProductTag = 1 THEN '001'
			WHEN t5.ProductTag = 10 THEN '010'
			WHEN t5.ProductTag = 11 THEN '011'
			WHEN t5.ProductTag = 100 THEN '100'
			WHEN t5.ProductTag = 101 THEN '101'
			WHEN t5.ProductTag = 110 THEN '110'
			WHEN t5.ProductTag = 111 THEN '111'
			ELSE '000'
		END ProductTag,
		CASE
			WHEN t5.ProductType = 1 THEN ISNULL(T13.FaceValueWithTax, 0)
			WHEN t5.ProductType = 2 THEN
				CASE
					WHEN t5.ProductSubType = 4 THEN ISNULL(t11.FaceValueWithTax, 0)
					ELSE ISNULL(T14.FaceValueWithTax, 0)
				END
			ELSE 0  
		END AS [FaceValueWithTax]
	FROM dbo.[Transaction] t1 WITH(NOLOCK)
	  JOIN dbo.Dictionary t2 WITH(NOLOCK) ON t1.TranType = t2.Name AND t2.Category = 'TransactionType'
	  LEFT JOIN dbo.Merchant t3 WITH(NOLOCK) ON t1.MerchantId = t3.Id
	  LEFT JOIN dbo.Shop t4 WITH(NOLOCK) ON t1.ShopId = t4.Id
	  LEFT JOIN dbo.Product t5 WITH(NOLOCK) ON t1.ProductId = t5.Id
	  LEFT JOIN dbo.[Order] t6 WITH(NOLOCK) ON t1.OrderId = t6.Id
	  LEFT JOIN dbo.OrderLine t7 WITH(NOLOCK) ON t7.OrderId = t6.Id AND t1.ClientQuotationProductId = t7.ClientQuotationProductId
	  LEFT JOIN dbo.ClientQuotationProduct t8 WITH(NOLOCK) ON t1.ClientQuotationProductId = t8.Id
	  LEFT JOIN dbo.Voucher t9 WITH(NOLOCK) ON t1.AccountNumber = t9.VoucherNumber
	  INNER JOIN dbo.Program t10 WITH(NOLOCK) ON t1.ProgramCode = t10.IdentityCode AND t9.ProgramId = t10.Id
	  INNER JOIN dbo.OrderBeneficiaryInfo t11 WITH(NOLOCK) ON t9.BeneficiaryInfoId = t11.Id
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
		AND T11.Id is not null

END
