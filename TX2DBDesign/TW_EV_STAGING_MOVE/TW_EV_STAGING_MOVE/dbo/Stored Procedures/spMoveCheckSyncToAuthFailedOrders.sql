CREATE PROCEDURE [dbo].[spMoveCheckSyncToAuthFailedOrders]      
AS      
BEGIN  

SET NOCOUNT ON

select distinct o.OrderNumber from [Order] o with(nolock)
inner join AdoraTask at with(nolock) on o.Id = at.OrderId
where Convert(CHAR(8),o.PublishDatetime,112) = Convert(CHAR(8),getdate(),112)
AND at.[Status] not in (2,4) AND o.[Status] = 32

END