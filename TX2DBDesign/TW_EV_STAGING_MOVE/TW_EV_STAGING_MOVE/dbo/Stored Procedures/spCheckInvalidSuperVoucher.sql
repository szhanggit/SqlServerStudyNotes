    
CREATE PROCEDURE [dbo].[spCheckInvalidSuperVoucher]                    
AS                    
BEGIN                
              
SET NOCOUNT ON              
              
  
  
  
DECLARE @MasterVouchers TABLE(  
MasterVoucher varchar(100)  
, MasterProgramId int  
, MasterBalanceInitialized int  
, ProductType int  
, BalanceInitialized int  
, FaceValueWithTax int  
, Balance int);  
  
  
  
insert into @MasterVouchers (  
MasterVoucher  
, MasterProgramId  
, MasterBalanceInitialized  
, ProductType  
, BalanceInitialized  
, FaceValueWithTax  
, Balance  
)  
select  
mv.VoucherNumber as MasterVoucher  
, mv.ProgramId as MasterProgramId  
, ma.BalanceInitialized as MasterBalanceInitialized  
, cpd.ProductType    
, ca.BalanceInitialized   
, PPPB.FaceValueWithTax  
, PPPB.Balance  
from VoucherCombo vc with(nolock)  
inner join Voucher mv with(nolock) on vc.MasterVoucherId = mv.Id  
inner join Product mpd with(nolock) on mv.ProductId = mpd.Id  
inner join Voucher cv with(nolock) on vc.ChildVoucherId = cv.Id  
inner join Product cpd with(nolock) on cv.ProductId = cpd.Id  
inner join TW_EV_UAT_ADORA.dbo.Program mp with(nolock) on mv.ProgramId = mp.ExternalId  
inner join TW_EV_UAT_ADORA.dbo.Account ma with(nolock) on mv.VoucherNumber = ma.AccountNumber AND mp.Id = ma.ProgramId  
inner join TW_EV_UAT_ADORA.dbo.Program cp with(nolock) on cv.ProgramId = cp.ExternalId  
inner join TW_EV_UAT_ADORA.dbo.Account ca with(nolock) on cv.VoucherNumber = ca.AccountNumber AND cp.Id = ca.ProgramId  
left join OrderBeneficiaryInfo cobi with(nolock) on cv.BeneficiaryInfoId = cobi.Id  
left join ProductVersion cpv with(nolock) on cobi.ProductVersionId = cpv.Id  
left join dbo.ProductPricingProductBased PPPB WITH(NOLOCK) ON cpv.ProductPricingProductBasedId = PPPB.Id  
where mv.[Status] = 32 AND mpd.ProductType = 2 AND mpd.ProductSubType = 8 AND vc.[Status] = 1   
insert into @MasterVouchers (  
MasterVoucher  
, MasterProgramId  
, MasterBalanceInitialized  
, ProductType  
, BalanceInitialized  
, FaceValueWithTax  
, Balance  
)  
select  
mv.VoucherNumber as MasterVoucher  
, mv.ProgramId as MasterProgramId  
, ma.BalanceInitialized as MasterBalanceInitialized  
, cpd.ProductType    
, ca.BalanceInitialized   
, PPPB.FaceValueWithTax  
, PPPB.Balance  
from VoucherCombo vc with(nolock)  
inner join Voucher mv with(nolock) on vc.MasterVoucherId = mv.Id  
inner join Product mpd with(nolock) on mv.ProductId = mpd.Id  
inner join Voucher cv with(nolock) on vc.ChildVoucherId = cv.Id  
inner join Product cpd with(nolock) on cv.ProductId = cpd.Id  
inner join TW_EV_UAT_ADORA.dbo.Program mp with(nolock) on mv.ProgramId = mp.ExternalId  
inner join TW_EV_UAT_ADORA.dbo.Account ma with(nolock) on mv.VoucherNumber = ma.AccountNumber AND mp.Id = ma.ProgramId  
inner join TW_EV_UAT_ADORA.dbo.Program cp with(nolock) on cv.ProgramId = cp.ExternalId  
inner join TW_EV_UAT_ADORA.dbo.AccountHistory ca with(nolock) on cv.VoucherNumber = ca.AccountNumber AND cp.Id = ca.ProgramId  
left join OrderBeneficiaryInfo cobi with(nolock) on cv.BeneficiaryInfoId = cobi.Id  
left join ProductVersion cpv with(nolock) on cobi.ProductVersionId = cpv.Id  
left join dbo.ProductPricingProductBased PPPB WITH(NOLOCK) ON cpv.ProductPricingProductBasedId = PPPB.Id  
where mv.[Status] = 32 AND mpd.ProductType = 2 AND mpd.ProductSubType = 8 AND vc.[Status] = 1   
  
  
  
  
  
select * from (select   
mv.MasterVoucher  
, mv.MasterProgramId  
, max(mv.MasterBalanceInitialized) as MasterBalanceInitialized  
, sum(case when ProductType = 2 then BalanceInitialized else FaceValueWithTax * Balance end) as ChildBalanceInitialized  
from @MasterVouchers mv  
group by mv.MasterVoucher, mv.MasterProgramId) temp  
where temp.MasterBalanceInitialized != temp.ChildBalanceInitialized  
              
END