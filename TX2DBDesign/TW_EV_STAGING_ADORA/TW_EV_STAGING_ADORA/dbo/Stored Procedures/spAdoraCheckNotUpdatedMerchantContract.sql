CREATE PROCEDURE [dbo].[spAdoraCheckNotUpdatedMerchantContract]      
AS      
BEGIN  

SET NOCOUNT ON

SELECT p.ProductCode
	, amc.StartDate AS NeedModifiedStartDate
	, CONVERT(CHAR(8),mc.ValidFrom,112) AS MoveStartDate
	, amc.EndDate AS NeedModifiedEndDate
	, CONVERT(CHAR(8),mc.ValidTo,112) AS MoveEndDate
FROM TW_EV_UAT_MOVE.dbo.MerchantContract mc WITH(NOLOCK)
INNER JOIN TW_EV_UAT_MOVE.dbo.ProductVersion pv WITH(NOLOCK) ON mc.ProductVersionId = pv.Id
INNER JOIN TW_EV_UAT_MOVE.dbo.Product p WITH(NOLOCK) ON pv.ProductId = p.Id
INNER JOIN TW_EV_UAT_MOVE.dbo.Merchant m WITH(NOLOCK) ON mc.MerchantId = m.Id
INNER JOIN TW_EV_UAT_MOVE.dbo.Program pg WITH(NOLOCK) ON p.ProgramId = pg.Id
INNER JOIN TW_EV_UAT_ADORA.dbo.MerchantContract amc WITH(NOLOCK) ON mc.Id = amc.ExternalId
WHERE p.[Status] = 1 
AND amc.EndDate > 20210713 
AND ((amc.StartDate != CONVERT(CHAR(8),mc.ValidFrom,112)) OR (amc.EndDate != CONVERT(CHAR(8),mc.ValidTo,112)))
ORDER BY p.ProductCode

END