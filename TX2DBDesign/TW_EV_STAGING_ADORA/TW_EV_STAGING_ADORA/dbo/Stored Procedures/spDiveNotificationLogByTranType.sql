CREATE PROCEDURE [dbo].[spDiveNotificationLogByTranType]               
 @DiveNotificationLogInfoList DiveNotificationLogInfo Readonly              
AS              
BEGIN              
 SET NOCOUNT ON;              
          
 update dnl          
 set dnl.NotificationItemId = dnlil.NotificationItemId          
 , dnl.DiveTranStatus = dnlil.TranStatus          
 , dnl.NotifiedOn = dnlil.NotifiedOn          
 , dnl.CreatedOn = dnlil.CreatedOn          
 , dnl.Response = dnlil.Response          
 from @DiveNotificationLogInfoList dnlil            
 inner join DiveNotificationLog dnl with(nolock) on dnlil.AccountNumber = dnl.AccountNumber                   
 AND DateDiff(second, dnl.TranLocalDateTime, dnlil.ActionDate) <= 1                
        
        
           
        
END     