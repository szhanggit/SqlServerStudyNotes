  
CREATE PROCEDURE spCheckShop  
AS  
BEGIN  
DECLARE @BatchName varchar(100);  
Set @BatchName = 'CheckShop'  
  
select @BatchName as [Name],count(1) as Result  
from Shop sm with(nolock)  
left join TW_EV_UAT_ADORA.dbo.Shop sa with(nolock) on sa.IdentityCode = sm.IdentityCode  
where sa.Status =1 and  sa.Id is null  
  
END  

