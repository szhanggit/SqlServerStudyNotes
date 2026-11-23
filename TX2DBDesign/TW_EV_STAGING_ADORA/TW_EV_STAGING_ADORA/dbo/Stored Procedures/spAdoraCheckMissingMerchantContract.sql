CREATE PROCEDURE [dbo].[spAdoraCheckMissingMerchantContract]      
AS      
BEGIN  

SET NOCOUNT ON

SELECT mc.Id AS ExternalId
	, m.IdentityCode AS MerchantCode
	, p.Id AS ProductExternalId
	, pg.IdentityCode AS ProgramCode
	, CONVERT(CHAR(8),mc.ValidFrom,112) AS StartDate
	, CONVERT(CHAR(8),mc.ValidTo,112) AS EndDate
FROM TW_EV_UAT_MOVE.dbo.MerchantContract mc WITH(NOLOCK)
INNER JOIN TW_EV_UAT_MOVE.dbo.ProductVersion pv WITH(NOLOCK) ON mc.ProductVersionId = pv.Id
INNER JOIN TW_EV_UAT_MOVE.dbo.Product p WITH(NOLOCK) ON pv.ProductId = p.Id
INNER JOIN TW_EV_UAT_MOVE.dbo.Merchant m WITH(NOLOCK) ON mc.MerchantId = m.Id
INNER JOIN TW_EV_UAT_MOVE.dbo.Program pg WITH(NOLOCK) ON p.ProgramId = pg.Id
LEFT JOIN TW_EV_UAT_ADORA.dbo.MerchantContract amc WITH(NOLOCK) ON mc.Id = amc.ExternalId
WHERE mc.ValidFrom <= GETDATE() 
AND mc.ValidTo >= GETDATE() 
AND amc.Id IS NULL 
AND p.[Status] = 1

END