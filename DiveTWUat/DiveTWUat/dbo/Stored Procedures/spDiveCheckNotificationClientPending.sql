CREATE PROCEDURE [dbo].spDiveCheckNotificationClientPending
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @BatchName varchar(100)
    Set @BatchName = 'DiveCheckNotificationClientPendingUAT'

SELECT  @BatchName as [Name],count(1) as Result from dbo.NotificationItem ni with(nolock) where ni.STATUS =1 AND ni.NotifiedOn IS NULL AND DATEDIFF(hh, ni.CreatedOn, getdate()) >=2

END
