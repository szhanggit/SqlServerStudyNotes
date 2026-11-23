CREATE PROCEDURE [dbo].spAccountBuffer2Check    
AS    
BEGIN    
    SET NOCOUNT ON    
    DECLARE @BatchName varchar(100)    
    Set @BatchName = 'ADORA_AccountBuffer2Check'    
 DECLARE @result int  
  
     select @result = count(1) from AccountBuffer2 with(nolock)     
 where DATEDIFF(hour, CreatedOn, GETUTCDATE()) > 1    
  
 if @result > 1  
 begin  
     select top 1 @BatchName as [Name], 999999999999 as Result from AccountBuffer2 with(nolock)     
 where DATEDIFF(hour, CreatedOn, GETUTCDATE()) > 1    
 end  
 else  
 begin  
     select @BatchName as [Name], 0 as Result  
 end  
  
  
END 

