
CREATE PROCEDURE [dbo].[spGetUsedTrustWarrantyDetail] 
	@ReportBatchNo VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
		ProductName
		,VoucherNumber
		,1 AS Quantity
		,ConsumeTime
		,ISNULL(T3.Name,'') AS ShopName
		,ISNULL(ConsumeShopCode,'') AS ShopCode
		,ConsumeTime AS ExchangeDate
	FROM [dbo].[EXT_TW_TrustAccountReportHistory] AS T1
	INNER JOIN [dbo].[EXT_TW_TrustAccountReport] AS T2 ON T1.ReportBatchNo = T2.ReportBatchNo
	LEFT JOIN [dbo].[Shop] AS T3 ON T1.ConsumeShopCode = T3.IdentityCode
	WHERE T1.ReportBatchNo = @ReportBatchNo
	AND T1.VoucherStatus = 32
END

