  
CREATE PROCEDURE [dbo].[spArchiveNotificationLog]       
 @NotificationLogList SingleIntListType Readonly      
AS      
BEGIN      
 SET NOCOUNT ON;      
 BEGIN TRAN  
 BEGIN TRY  
  
    insert into ArchiveDiveNotificationLog (DiveNotificationLogId  
 , AccountNumber  
 , ProgramCode  
 , TranCode  
 , TranType  
 , TranLocalDateTime  
 , TranLocalDate  
 , OrderNum  
 , OrderNumOnDive  
 , NotificationItemId  
 , DiveTranStatus  
 , NotifiedOn  
 , CreatedOn  
 , Response
 , Fixed)  
 select nl.Id as DiveNotificationLogId  
 , nl.AccountNumber  
 , nl.ProgramCode  
 , nl.TranCode  
 , nl.TranType  
 , nl.TranLocalDateTime  
 , nl.TranLocalDate  
 , nl.OrderNum  
 , nl.OrderNumOnDive  
 , nl.NotificationItemId  
 , nl.DiveTranStatus  
 , nl.NotifiedOn  
 , nl.CreatedOn  
 , nl.Response   
 , nl.Fixed
 from @NotificationLogList list  
 inner join DiveNotificationLog nl with(nolock) on list.Id = nl.Id  
  
 delete nl from @NotificationLogList list  
 inner join DiveNotificationLog nl with(nolock) on list.Id = nl.Id  
  
 COMMIT TRANSACTION;  
 END TRY  
 BEGIN CATCH  
  IF @@TRANCOUNT > 0  
   ROLLBACK TRANSACTION;  
 END CATCH;  
END 