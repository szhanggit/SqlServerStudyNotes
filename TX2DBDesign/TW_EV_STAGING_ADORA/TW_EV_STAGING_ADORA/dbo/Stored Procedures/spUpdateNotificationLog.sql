
CREATE PROCEDURE [dbo].[spUpdateNotificationLog]     
 @NotificationLogList TripleIntListType Readonly    
AS    
BEGIN    
 SET NOCOUNT ON;    
	BEGIN TRAN
	BEGIN TRY

	update dlog
    set dlog.OrderNum = list.OrderNum 
	from @NotificationLogList list
	inner join DiveNotificationLog dlog with(nolock) on list.Id = dlog.Id
	where dlog.OrderNum is null

	update dlog
	set dlog.OrderNumOnDive = list.OrderNumOnDive 
	from @NotificationLogList list
	inner join DiveNotificationLog dlog with(nolock) on list.Id = dlog.Id
	where dlog.OrderNumOnDive is null AND list.OrderNumOnDive is not null

	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;
END 