
CREATE PROCEDURE [dbo].[spGetTrashedTrustWarrantyDetail] 
	@ReportBatchNo VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
		ProductName
		,VoucherNumber
		,1 AS Quantity
		,LastTranOn AS ConsumeTime
		,LastTranOn AS ExchangeDate
		,'Trashed' AS TransactionContent
		,T2.Brand
	FROM [dbo].[EXT_TW_TrustAccountReportHistory] AS T1
	INNER JOIN [dbo].[EXT_TW_TrustAccountReport] AS T2 ON T1.ReportBatchNo = T2.ReportBatchNo
	WHERE T1.ReportBatchNo = @ReportBatchNo
	AND T1.VoucherStatus = 8
END

