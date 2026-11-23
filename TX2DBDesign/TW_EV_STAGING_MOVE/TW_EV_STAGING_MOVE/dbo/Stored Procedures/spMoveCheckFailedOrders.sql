CREATE PROCEDURE [dbo].[spMoveCheckFailedOrders]      
AS      
BEGIN  

SET NOCOUNT ON

SELECT Id
	,ClientQuotationId
	,OrderNumber
	,Mode
	,IsDirectDelivery
	,PublishDatetime
	,[Status]
	,ExecutingStatus
	,ExecutingResponse
	,CreatedBy
	,CreatedOn
FROM [Order] WITH(NOLOCK)
WHERE [Status] = 32 and ExecutingStatus in (1,3,5,7)

END