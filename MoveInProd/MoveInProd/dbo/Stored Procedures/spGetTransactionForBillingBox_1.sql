
CREATE PROCEDURE spGetTransactionForBillingBox 
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
		t5.ProductName,
		t5.ProductCode,
		CASE WHEN t5.ProductType = 1 THEN t12.SoldPriceWithTax 
			ELSE t12.ValueBasedSoldPriceWithTax END AS SoldPriceWithTax,
		CASE WHEN t5.ProductType = 1 THEN t12.SoldPriceWithoutTax 
			ELSE t12.ValueBasedSoldPriceWithoutTax END AS SoldPriceWithoutTax,
		--T7.SoldPriceWithTax,--ROUND(t7.SoldPrice * 1.05,2) AS SoldPriceWithTax,
		--t7.SoldPrice AS SoldPriceWithoutTax,
		t8.ClientQuotationId AS [QuotationId],
		t6.Id AS [OrderId],
		t6.OrderName,
		t11.ClientOrderNumber,
		t1.ServiceFee,
		t1.Rsv1,
		t1.Rsv2,
		t1.Rsv3,
		t9.VoucherNumber,
		t9.[GUID] AS [VoucherGuid],
		t11.Email,
		t11.Mobile,
		t11.Memo
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
	  LEFT JOIN dbo.OrderBeneficiaryInfo t11 WITH(NOLOCK) ON t9.BeneficiaryInfoId = t11.Id
	  LEFT JOIN [dbo].[ClientQuotationProductSoldPrice] AS t12 ON t8.Id = t12.[ClientQuotationProductId]
	  															AND t12.ValidityFrom <= t11.ActiveDate
																AND t12.ValidityEnd >= t11.ActiveDate
																AND T12.Status = 2
	WHERE t1.TranLocalDate = @DateInt
		AND T1.ResponseCode = '0000'


END
