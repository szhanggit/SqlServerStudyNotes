CREATE PROCEDURE [dbo].[spGetTrustWarrantyDetail]   
 @ReportBatchNo VARCHAR(50)  
 ,@VoucherStatus INT  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 SELECT   
  ProductName  
  ,VoucherNumber  
  ,1 AS Quantity  
  ,CASE WHEN @VoucherStatus = 32 THEN ConsumeTime  
    ELSE LastTranOn END AS ConsumeTime  
  ,ISNULL(T3.Name,'') AS ShopName  
  ,ISNULL(ConsumeShopCode,'') AS ShopCode  
  ,CASE WHEN @VoucherStatus = 32 THEN ConsumeTime  
    ELSE LastTranOn END AS ExchangeDate  
 FROM [dbo].[EXT_TW_TrustAccountReportHistory] AS T1  
 INNER JOIN [dbo].[EXT_TW_TrustAccountReport] AS T2 ON T1.ReportBatchNo = T2.ReportBatchNo  
 LEFT JOIN  [dbo].[Merchant] AS M ON T1.ConsumeMerchantCode = M.IdentityCode  
 LEFT JOIN [dbo].[Shop] AS T3 ON T1.ConsumeShopCode = T3.IdentityCode AND T3.MerchantId = M.ID
 WHERE T1.ReportBatchNo = @ReportBatchNo  
 AND T1.VoucherStatus = @VoucherStatus  
END