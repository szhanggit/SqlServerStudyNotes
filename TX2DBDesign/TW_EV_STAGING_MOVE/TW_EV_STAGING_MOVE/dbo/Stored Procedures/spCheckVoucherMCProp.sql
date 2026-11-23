create procedure spCheckVoucherMCProp
	@Voucher varchar(50)
	, @ProgramCode varchar(50)
	, @OrderNumber varchar(50)
	, @MasterVoucher varchar(50) output
	, @ChildVoucher varchar(50) output
	, @res varchar(10) output
	, @VoucherNumberGenerateWay int output
	, @IsMasterProduct int output
	, @BeneficiaryInfoId int output
	, @IsFakeBeneficiaryInfoId int output
AS
BEGIN

Declare @ProductCode varchar(50);
Declare @OrderLineId int;
Declare @ProductVersionId int;
select @VoucherNumberGenerateWay = p.VoucherNumberGenerateWay
, @IsMasterProduct = p.IsMasterProduct
, @BeneficiaryInfoId = v.BeneficiaryInfoId 
, @ProductCode = p.ProductCode
from Voucher v with(nolock)
inner join Program pg with(nolock) on v.ProgramId = pg.Id
inner join Product p with(nolock) on v.ProductId = p.Id
where v.VoucherNumber = @Voucher AND pg.IdentityCode = @ProgramCode

if @BeneficiaryInfoId is null or @BeneficiaryInfoId = ''
begin
	set @IsFakeBeneficiaryInfoId = 1;
	select @OrderLineId = ol.Id, @ProductVersionId = pv.Id from OrderLine ol WITH(nolock) 
	inner join [Order] o with(nolock) on ol.OrderId = o.Id
	JOIN dbo.ClientQuotationProduct cqp WITH(nolock) ON ol.ClientQuotationProductId = cqp.Id
	JOIN dbo.ClientQuotation cq WITH(NOLOCK) ON cqp.ClientQuotationId = cq.Id
	JOIN dbo.Client c WITH(NOLOCK) ON cq.ClientId = c.Id
	JOIN dbo.ProductVersion pv WITH(NOLOCK) ON cqp.ProductVersionId = pv.Id
	JOIN dbo.Product p WITH(NOLOCK) ON p.Id = pv.ProductId
	where o.OrderNumber = @OrderNumber AND p.ProductCode = @ProductCode


	insert into OrderBeneficiaryInfo(OrderLineId, VoucherQuantity, ExpirySchemeId, Memo, ActiveDate, ProductVersionId) 
	values (@OrderLineId, 0, 0, 'Fake', GETDATE(), @ProductVersionId);
	SELECT @BeneficiaryInfoId = SCOPE_IDENTITY();


	update v
	set v.BeneficiaryInfoId = @BeneficiaryInfoId
	from Voucher v with(nolock)
	inner join Program pg with(nolock) on v.ProgramId = pg.Id
	inner join Product p with(nolock) on v.ProductId = p.Id
	where v.VoucherNumber = @Voucher AND pg.IdentityCode = @ProgramCode
end
else
begin
	set @IsFakeBeneficiaryInfoId = 0;
end



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