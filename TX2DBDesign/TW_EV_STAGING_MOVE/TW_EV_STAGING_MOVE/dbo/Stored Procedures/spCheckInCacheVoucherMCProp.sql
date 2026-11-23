create procedure spCheckInCacheVoucherMCProp
	@Voucher varchar(50)
	, @ProgramCode varchar(50)
	, @MasterVoucher varchar(50) output
	, @ChildVoucher varchar(50) output
	, @res varchar(10) output
	, @VoucherNumberGenerateWay int output
	, @IsMasterProduct int output
AS
BEGIN

Declare @ProductCode varchar(50);
Declare @OrderLineId int;
select @VoucherNumberGenerateWay = p.VoucherNumberGenerateWay
, @IsMasterProduct = p.IsMasterProduct
, @ProductCode = p.ProductCode
from Voucher v with(nolock)
inner join Program pg with(nolock) on v.ProgramId = pg.Id
inner join Product p with(nolock) on v.ProductId = p.Id
where v.VoucherNumber = @Voucher AND pg.IdentityCode = @ProgramCode





set @res = 'R';	--Regular

select @ChildVoucher = cv.VoucherNumber, @MasterVoucher = mv.VoucherNumber
from VoucherCombo vc with(nolock)
inner join Voucher mv with(nolock) on vc.MasterVoucherId = mv.Id
inner join Voucher cv with(nolock) on vc.ChildVoucherId = cv.Id
inner join Program p with(nolock) on p.Id = mv.ProgramId
where vc.[Status] = 1 AND mv.VoucherNumber = @Voucher AND p.IdentityCode = @ProgramCode

if @MasterVoucher is not null
begin
	set @res = 'M';	--Master
	return 1;
end


select @ChildVoucher = cv.VoucherNumber, @MasterVoucher = mv.VoucherNumber
from VoucherCombo vc with(nolock)
inner join Voucher mv with(nolock) on vc.MasterVoucherId = mv.Id
inner join Voucher cv with(nolock) on vc.ChildVoucherId = cv.Id
inner join Program p with(nolock) on p.Id = cv.ProgramId
where vc.[Status] = 1 AND cv.VoucherNumber = @Voucher AND p.IdentityCode = @ProgramCode


if @ChildVoucher is not null
begin
	set @res = 'C';	--Child
	return 1;
end


END