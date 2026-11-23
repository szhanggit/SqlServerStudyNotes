  
CREATE PROCEDURE [dbo].[spFetchAdoraBatchData_PreAuthorizationExpireJob]        
AS        
BEGIN        
    SET NOCOUNT ON        
DECLARE @BatchName varchar(50) = 'ADORA_PreAuthorizationExpireJob';    
DECLARE @BatchType int       
Set @BatchType = 1        
      
 DECLARE @FailureCount int = 0;      
 DECLARE @RunningStatusList TABLE([Status] int);         
 insert into @RunningStatusList ([Status])      
 select top 2 [Status] from Batch with(nolock)         
 where BatchType = @BatchType AND [Status] is not null AND [Status] != '' AND [Status] != 1      
 order by Id desc;        
 select @FailureCount = count(1) from @RunningStatusList where [Status] = 2      
 if @FailureCount = 0      
 begin      
  select top 1 @BatchName as [Name],DATEDIFF(Second, StartTime, GETUTCDATE()) as Result from Batch with(nolock)         
  where BatchType = @BatchType        
  order by Id desc;         
 end      
 else if @FailureCount = 1      
 begin      
 select @BatchName as [Name], 888888888888 as Result      
 end      
 else if @FailureCount = 2      
 begin      
 select @BatchName as [Name], 999999999999 as Result      
 end      
END 

