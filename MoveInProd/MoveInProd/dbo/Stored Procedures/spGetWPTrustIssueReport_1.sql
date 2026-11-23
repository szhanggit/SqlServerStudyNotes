-- =============================================
-- Author:		Zhu Jianhua
-- Create date: 2017/7/21
-- Description:	spGetWPTurstIssueReport
-- =============================================
CREATE PROCEDURE [dbo].[spGetWPTrustIssueReport]
	-- Add the parameters for the stored procedure here
     @FromDate	DATETIME
	,@ToDate	DATETIME
	,@Brand     varchar(50)  = NULL
	,@PageStart int 
	,@PageSize int 
	,@TotalCount int out
AS
BEGIN

SELECT 
	B.ClientName
	,B.ProductCode
	,B.ProductName
	,B.ActiveDate
	,B.BatchNo
	,IssueQuantity 
FROM 
(
	SELECT A.ClientName,A.ProductCode,A.ProductName,A.ActiveDate,A.BatchNo
	,COUNT(1) AS IssueQuantity
	,ROW_NUMBER() OVER(ORDER BY A.ProductCode) as rownumber 
	FROM 
	(SELECT 
			T8.[Name] AS ClientName
			, T9.ProductCode AS ProductCode
			, T9.ProductName AS ProductName
			, convert (datetime2, convert(varchar(255), T1.ActivatedOn, 102) ,  102) AS ActiveDate
			, T3.TrustAccountBatchNo AS BatchNo
		FROM [dbo].[Voucher] AS T1
			INNER JOIN [dbo].[Product] AS T9 ON T1.ProductId = T9.Id
			INNER JOIN [dbo].[ProductExternalPropertySet] AS T10 ON T9.[ExternalPropertyId] = T10.[ProductExternalPropertyId]
			INNER JOIN [dbo].[OrderBeneficiaryInfo] AS T4 ON T1.[BeneficiaryInfoId] = T4.[Id]
			INNER JOIN EXT_TW_OrderLineTrustAccount as T3 ON T4.OrderLineId = T3.Id
			LEFT JOIN [dbo].[OrderLine] AS T5 ON T4.[OrderLineId] = T5.[Id]
			LEFT JOIN [dbo].[ClientQuotationProduct] AS T6 ON T5.[ClientQuotationProductId] = T6.[Id]
			LEFT JOIN [dbo].[ClientQuotation] AS T7 ON T6.[ClientQuotationId] = T7.[Id]
			LEFT JOIN [dbo].[Client] AS T8 ON T7.[ClientId] = T8.[Id]
		WHERE (T10.PropertyName='Brand' and T10.PropertyValue='wowprime')
		AND T1.[ActivatedOn] >= @FromDate 
		AND T1.[ActivatedOn] < @ToDate
		AND (isnull(@Brand,'')='' or T9.ProductCode like ''+@Brand+'%')
	) AS A
	GROUP BY A.ClientName,A.ProductCode,A.ProductName,A.ActiveDate,A.BatchNo) AS B
	WHERE rownumber>@PageStart
		AND rownumber<=@PageStart + @PageSize


	SELECT @TotalCount = COUNT(1) 
	FROM (
	SELECT 
				T8.[Name] AS ClientName
				, T9.ProductCode AS ProductCode
				, T9.ProductName AS ProductName
				, convert (datetime2, convert(varchar(255), T1.ActivatedOn, 102) ,  102) AS ActiveDate
				, T3.TrustAccountBatchNo AS BatchNo
			FROM [dbo].[Voucher] AS T1
				INNER JOIN [dbo].[Product] AS T9 ON T1.ProductId = T9.Id
				INNER JOIN [dbo].[ProductExternalPropertySet] AS T10 ON T9.[ExternalPropertyId] = T10.[ProductExternalPropertyId]
				INNER JOIN [dbo].[OrderBeneficiaryInfo] AS T4 ON T1.[BeneficiaryInfoId] = T4.[Id]
				INNER JOIN EXT_TW_OrderLineTrustAccount as T3 ON T4.OrderLineId = T3.Id
				LEFT JOIN [dbo].[OrderLine] AS T5 ON T4.[OrderLineId] = T5.[Id]
				LEFT JOIN [dbo].[ClientQuotationProduct] AS T6 ON T5.[ClientQuotationProductId] = T6.[Id]
				LEFT JOIN [dbo].[ClientQuotation] AS T7 ON T6.[ClientQuotationId] = T7.[Id]
				LEFT JOIN [dbo].[Client] AS T8 ON T7.[ClientId] = T8.[Id]
			WHERE (T10.PropertyName='Brand' and T10.PropertyValue='wowprime')
			AND T1.[ActivatedOn] >=  @FromDate
			AND T1.[ActivatedOn] < @ToDate
			AND (isnull(@Brand,'')='' or T9.ProductCode like ''+@Brand+'%')
		) AS A
		GROUP BY A.ClientName,A.ProductCode,A.ProductName,A.ActiveDate,A.BatchNo

END


