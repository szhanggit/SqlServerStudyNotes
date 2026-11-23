
CREATE PROCEDURE [dbo].[spGetIssueTrustWarrantyDetail] 
	@ReportBatchNo VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
		T1.PublishedOn
		,T2.TrustAccountBatchNo AS BatchNo
		,T2.[GuaranteedEndDate]
		,VoucherNumber
		,ProductName
		,TrustAccountAmount AS TrustAmount
	FROM [dbo].[EXT_TW_TrustAccountReportHistory] AS T1
	INNER JOIN [dbo].[EXT_TW_TrustAccountReport] AS T2 ON T1.ReportBatchNo = T2.ReportBatchNo
	LEFT JOIN [dbo].[Shop] AS T3 ON T1.ConsumeShopCode = T3.IdentityCode
	WHERE T1.ReportBatchNo = @ReportBatchNo
	AND T2.ReportType = 1
END

