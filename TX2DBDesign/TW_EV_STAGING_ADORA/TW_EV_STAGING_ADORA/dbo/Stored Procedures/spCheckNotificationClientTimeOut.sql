  
CREATE PROCEDURE [dbo].[spCheckNotificationClientTimeOut]    
AS    
BEGIN    
    SET NOCOUNT ON    
    DECLARE @BatchName varchar(100)    
    Set @BatchName = 'CheckNotificationClientTimeOut'    
    DECLARE @Result int = 0;  
  
 SELECT @Result = count(1) from dbo.NotificationItem ni with(nolock)    
    where ni.STATUS =0 AND len(ni.LastResponse)> 0 AND ni.LastNotifiedOn IS NULL AND ni.TryCount = 0 and CreatedOn > DATEADD(DAY,-7,GETUTCDATE())    
  
 if @Result > 0  
 begin  
  SELECT  @BatchName as [Name], 999999999999 as Result   
 end  
 else  
 begin  
  SELECT  @BatchName as [Name],0 as Result   
 end  
   
    
END    
  
  
  

