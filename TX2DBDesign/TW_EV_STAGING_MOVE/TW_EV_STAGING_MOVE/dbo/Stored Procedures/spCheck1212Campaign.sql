  
CREATE PROCEDURE spCheck1212Campaign  
AS  
BEGIN  
DECLARE @BatchName varchar(100);  
Set @BatchName = 'Check1212Campaign'  
  
select @BatchName as [Name],count(1) as Result  
from PreIssuedCampaignVoucher p with(nolock)  
join Voucher v with(nolock) on v.Id = p.VoucherId  
join TW_EV_UAT_ADORA.dbo.Account ada with(nolock) on ada.AccountNumber = v.VoucherNumber  
where p.OrderNumber = '202011183755' and p.CreatedOn<DATEADD(HOUR,-6,GETDATE()) and p.CreatedOn>DATEADD(HOUR,-30,GETDATE()) and ProcessStatus = 2 and ada.ActivatedOn is null  
END  

