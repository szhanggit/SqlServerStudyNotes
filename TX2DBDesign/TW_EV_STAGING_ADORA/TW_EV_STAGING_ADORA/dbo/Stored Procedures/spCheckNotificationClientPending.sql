CREATE PROCEDURE [dbo].spCheckNotificationClientPending  
AS  
BEGIN  
    SET NOCOUNT ON  
    DECLARE @BatchName varchar(100)  
    Set @BatchName = 'CheckNotificationClientPending'  
  
SELECT  @BatchName as [Name],count(1) as Result from dbo.NotificationItem ni with(nolock)  
where ni.STATUS =0 AND ni.LastNotifiedOn IS NULL AND DATEDIFF(hh, ni.CreatedOn, GETUTCDATE()) >=2 AND ni.TryCount = 0  
  
END  

