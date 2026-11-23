     
CREATE PROCEDURE spFetchMoveBatchData_DoUpdateBatchTransactionJob    
AS    
BEGIN    
  
DECLARE @BatchName varchar(100)    
Set @BatchName = 'DoUpdateBatchTransactionJob'    
  
 DECLARE @FailureCount int = 0;  
 DECLARE @RunningStatusList TABLE([Status] int);     
 insert into @RunningStatusList ([Status])  
 select top 2 [Status] from BatchLog with(nolock)     
 where BatchName = @BatchName AND [Status] is not null AND [Status] != '' AND [Status] != 1  
 order by Id desc;    
 select @FailureCount = count(1) from @RunningStatusList where [Status] = 2  
 if @FailureCount = 0  
 begin  
  select top 1 @BatchName as [Name],DATEDIFF(Second, ExecuteStartTime, GETDATE()) as Result from BatchLog with(nolock)     
  where BatchName = @BatchName    
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

