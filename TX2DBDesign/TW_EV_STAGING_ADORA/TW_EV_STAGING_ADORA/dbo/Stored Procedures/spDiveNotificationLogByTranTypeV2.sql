
create PROCEDURE [dbo].[spDiveNotificationLogByTranTypeV2]                 
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
 , dnl.OrderNum = null
 , dnl.OrderNumOnDive = null
 from @DiveNotificationLogInfoList dnlil              
 inner join DiveNotificationLog dnl with(nolock) on dnlil.AccountNumber = dnl.AccountNumber                     
 AND DateDiff(second, dnl.TranLocalDateTime, dnlil.ActionDate) = 0                  
          
          
             
          
END 