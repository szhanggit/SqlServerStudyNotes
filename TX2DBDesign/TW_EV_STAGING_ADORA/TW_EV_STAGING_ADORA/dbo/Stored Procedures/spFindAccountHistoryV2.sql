
CREATE PROCEDURE spFindAccountHistoryV2    
 -- Add the parameters for the stored procedure here    
 @AcountNumber  varchar(50)    
 ,@ProgramCode  varchar(50)    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
 SELECT a.*   
 FROM [dbo].[AccountHistory] a with(nolock)  
 inner join Program p with(nolock) on a.ProgramId = p.Id  
 WHERE [AccountNumber] = @AcountNumber AND p.IdentityCode = @ProgramCode    
END 