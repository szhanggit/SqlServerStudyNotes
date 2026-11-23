  
CREATE PROCEDURE spCheckOrderSyncToAuthFail  
AS  
BEGIN  
DECLARE @BatchName varchar(100);  
Set @BatchName = 'CheckOrderSyncToAuthFail'  
  
select @BatchName as [Name],count(1) as Result  
from [Order] with(nolock)  
where [Status] = 32 and ExecutingStatus = 5  
and PublishDatetime < DATEADD(day, -1, GETDATE())  
and PublishDatetime > DATEADD(day, -60, GETDATE())  
  
END  

