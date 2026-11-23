CREATE PROCEDURE spFindAccountV2    
 @AcountNumber  varchar(50)    
 ,@ProgramCode  varchar(50)    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
 SELECT a.*  
 FROM [dbo].[Account] a with(nolock)  
 inner join Program p with(nolock) on a.ProgramId = p.Id  
 WHERE a.[AccountNumber] = @AcountNumber AND p.IdentityCode = @ProgramCode    
END 