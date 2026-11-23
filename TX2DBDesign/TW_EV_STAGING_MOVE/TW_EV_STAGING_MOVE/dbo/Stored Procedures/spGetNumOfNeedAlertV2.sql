
CREATE PROCEDURE [dbo].[spGetNumOfNeedAlertV2]  
 @Window INT = 10  
    ,@AlertId INT = 0   
AS  
BEGIN  
 SET NOCOUNT ON;  
 declare @NumOfNeedAlert int = 0  
 ;with TempAlertTable(  
  AlertId  
  , AlertName  
  , CreateTime  
  , NeedAlert  
 ) AS (select temp.AlertId, temp.AlertName, temp.CreateTime, temp.NeedAlert from (select AlertId, AlertName, CreateTime, NeedAlert, ROW_NUMBER() OVER(PARTITION BY AlertId ORDER BY CreateTime desc) rownum   
 from SupportMonitor_Result_History with(nolock)   
 where AlertId = @AlertId AND CreateTime > DATEADD(hour, -8, GETDATE())) temp  
 where temp.rownum < @Window)  
 select @AlertId as AlertId, count(1) as NeedAlertNum, getdate() as LastUpdateTime from TempAlertTable with(nolock) where NeedAlert = 1  
END  
