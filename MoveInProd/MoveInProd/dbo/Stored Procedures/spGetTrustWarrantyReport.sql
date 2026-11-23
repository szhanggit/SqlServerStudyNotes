
CREATE PROCEDURE [dbo].[spGetTrustWarrantyReport] 
	@BatchNo VARCHAR(50)
	,@CreateDateStart int
	,@CreateDateEnd int
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
		CASE WHEN ReportType = 1 THEN 'Issue'
			WHEN ReportType = 2 THEN 'Month'
			ELSE '' END AS ReportType
		,MONTH(CreatedOn)AS ReportMonth
		,Brand
		,TrustAccountBatchNo AS BatchNo 
		,TrustAccountBank AS TrustBank
		,'' AS CouponNo
		,CONVERT(VARCHAR(8),[GuaranteedStartDate])+ ' - '+ CONVERT(VARCHAR(8),[GuaranteedEndDate]) AS GuaranteedSpan
		,0 AS StockQuantity
		,IssuedQuantity AS SelasQuantity
		,UsedQuantity
		,TrashedQuantity
		,ActiveQuantity AS TrustQuantity
		,0 AS VoidQuantity
		,TrustAccountAmount AS MarketPrice
		,BankCommission
		,GuaranteedAmount AS GuaranteedQuantity
		,ReportBatchNo
	FROM [dbo].[EXT_TW_TrustAccountReport]
	WHERE (ReportType = 1 OR ReportType = 2)
	AND ReportDate BETWEEN @CreateDateStart AND  @CreateDateEnd
	AND (ISNULL(@BatchNo,'')='' OR [TrustAccountBatchNo] LIKE '%'+@BatchNo+'%')
END

