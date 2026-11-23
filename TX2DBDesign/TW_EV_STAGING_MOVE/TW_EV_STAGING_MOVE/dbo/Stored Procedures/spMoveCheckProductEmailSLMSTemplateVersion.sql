CREATE PROCEDURE [dbo].[spMoveCheckProductEmailSLMSTemplateVersion]      
AS      
BEGIN  

SET NOCOUNT ON

SELECT p.ProductCode
	, pv.ProductEmailTemplateVersionId AS 'ProductEmailTemplateVersionId_PV'
	, p.ProductEmailTemplateVersionId
	, pv.ProductSLMSTemplateVersionId AS 'ProductSLMSTemplateVersionId_PV'
	, p.ProductSLMSTemplateVersionId 
FROM Product p WITH(NOLOCK)
INNER JOIN ProductVersion pv WITH(NOLOCK) ON p.Id = pv.ProductId AND pv.IsCurrentVersion = 1
WHERE (pv.ProductEmailTemplateVersionId != p.ProductEmailTemplateVersionId
OR pv.ProductSLMSTemplateVersionId != p.ProductSLMSTemplateVersionId)
AND p.[Status] = 1 
AND p.CanIssue = 1

END