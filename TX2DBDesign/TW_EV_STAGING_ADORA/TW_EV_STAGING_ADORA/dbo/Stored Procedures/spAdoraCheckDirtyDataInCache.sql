CREATE PROCEDURE [dbo].[spAdoraCheckDirtyDataInCache]        
AS        
BEGIN    
  
SET NOCOUNT ON  
  
select v.VoucherNumber, v.ProgramId  
from TW_EV_UAT_MOVE.dbo.PreIssueVoucherInfo v with(nolock)    
left join TW_EV_UAT_ADORA.dbo.Account a with(nolock) on a.AccountNumber = v.VoucherNumber  
where v.[Status] = 256 AND a.AccountNumber is null  
  
END