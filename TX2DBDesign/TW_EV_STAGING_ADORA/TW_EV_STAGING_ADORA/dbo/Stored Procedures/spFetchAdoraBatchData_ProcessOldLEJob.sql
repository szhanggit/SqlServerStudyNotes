CREATE PROCEDURE [dbo].[spFetchAdoraBatchData_ProcessOldLEJob]  
AS  
BEGIN  
    SET NOCOUNT ON  
    DECLARE @BatchName varchar(100)  
    Set @BatchName = 'ADORA_ProcessOldLEJob'  
  
    select top 1 @BatchName as [Name],DATEDIFF(Second, StartTime, GETUTCDATE()) as Result from Batch with(nolock)   
 where [Status] = 8 AND BatchType = 16384  
 order by Id desc;  
END  

