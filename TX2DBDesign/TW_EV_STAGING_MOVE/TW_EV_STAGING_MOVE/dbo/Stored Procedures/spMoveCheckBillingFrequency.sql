CREATE PROCEDURE [dbo].[spMoveCheckBillingFrequency]      
AS      
BEGIN  

SET NOCOUNT ON

SELECT q.[Id]
	,[ClientId]
	,[QuotationNumber]
	,[ProjectName]
	,[QuotationType]
	,[BusinessModelId]
	,[BillingFrequency]
	,f.DisplayName AS 'BillingFrequency_name'
	,[BillingDate]
	,d.DisplayName AS 'BillingDate_name'
	,d.ParentId
	,q.ModifiedOn
FROM [ClientQuotation] q WITH(NOLOCK)
LEFT JOIN [Dictionary] f WITH(NOLOCK) ON f.Category = 'BBXBillingFrequency' AND q.BillingFrequency = f.Id
LEFT JOIN [Dictionary] d WITH(NOLOCK) ON q.BillingDate = d.Id
WHERE ([BillingFrequency] != 253 
AND [BillingDate] != 294) 
AND d.ParentId != [BillingFrequency]
ORDER BY q.id

END