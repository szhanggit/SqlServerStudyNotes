CREATE PROCEDURE [dbo].[spGetVoucherComboByVoucherGuid]
	@GuidString varchar(100)
AS
    BEGIN
    declare @inputVoucherId bigint  
  
    select @inputVoucherId = v.Id  
    from Voucher v with(nolock)  
    where v.[GUID] = @guidString

    select v.Id,  
    v.VoucherNumber,  
    v.[GUID] as VoucherGuid,  
    pg.IdentityCode as ProgramCode,  
    o.OrderNumber,  
    v.ExpiryDate,  
    p.ProductType,  
    p.IsMasterProduct,  
    p.ProductSubType,  -- VoucherType  
    p.ProductCode,  
    v.BalanceAvailable,  
    v.[Status] as VoucherStatus,
	case 
	when exists(select 1 from dbo.VoucherCombo with(nolock) where MasterVoucherId = v.Id) 
	then (select top(1) [Status] from dbo.VoucherCombo with(nolock) where MasterVoucherId = v.Id) 
	when exists(select 1 from dbo.VoucherCombo with(nolock) where ChildVoucherId = v.Id) 
	then (select top(1) [Status] from dbo.VoucherCombo with(nolock) where ChildVoucherId = v.Id)
	else 0
	end as ComboStatus
    from Voucher v with(nolock)  
    join Program pg with(nolock) on v.ProgramId = pg.Id  
    join Product p with(nolock) on v.ProductId = p.Id  
    join OrderBeneficiaryInfo obi with(nolock) on v.BeneficiaryInfoId = obi.Id  
    join OrderLine ol with(nolock) on obi.OrderLineId = ol.Id  
    join [Order] o with(nolock) on ol.OrderId = o.Id  
    where v.Id in   
    (  
        select @inputVoucherId  
        UNION  
        select ChildVoucherId   
        from dbo.VoucherCombo with(nolock)   
        where MasterVoucherId = @inputVoucherId and status = 1  
        UNION  
        select MasterVoucherId  
        from dbo.VoucherCombo with(nolock)   
        where ChildVoucherId = @inputVoucherId and status = 1  
    )  
    END