CREATE PROCEDURE [dbo].[spQueryNeedResendVoucherListByEmail] 
	@Email	varchar(50) = null,
	@Mobile varchar(50) = null,
	@startDate datetime,
	@endDate datetime,
	@BusinessTypes varchar(500) = null,
	@PageNumber int,
	@PageSize int,
	@BusinessModelIds varchar(500) = null,
	@OrderName nvarchar(200) = null,
	@ProductName nvarchar(200) = null
AS
BEGIN
	set nocount on;

	declare @sql nvarchar(3000);

	set @sql = 'declare @totalCount int = 0;
				select @totalCount = count(1) from Voucher v with(nolock,forceseek)
					join OrderBeneficiaryInfo obi with(nolock) on v.BeneficiaryInfoId = obi.Id
					join OrderLine ol with(nolock) on obi.OrderLineId = ol.Id
					join [Order] o with(nolock) on ol.OrderId = o.Id
					join ClientQuotation cq with(nolock) on o.ClientQuotationId = cq.Id
					left join BusinessModel bm with(nolock) on bm.Id = cq.BusinessModelId
					join Product p with(nolock) on v.ProductId = p.Id
				where v.[Status] in(2,32)
					and v.ActivatedOn >= @startDate and v.ActivatedOn <=@endDate';

	if @Email is null or @Email = ''
		set @sql = @sql + ' and obi.Mobile = @Mobile'
	else
		set @sql = @sql + ' and obi.Email = @Email'

	if @BusinessTypes is not null
		set @sql = @sql + ' and cq.BusinessTypeId in ('+@BusinessTypes+')'

	if @BusinessModelIds is not null
		set @sql = @sql + ' and bm.DisplayNameId in('+@BusinessModelIds+')'

	if @OrderName is not null
		set @sql = @sql + ' and o.OrderName like N''%'+@OrderName+'%'''

	if @ProductName is not null
		set @sql = @sql + ' and p.ProductName like N''%'+@ProductName+'%'''

	set @sql = @sql + ';
						select @totalCount TotalCount;
					    if @totalCount <=0
							return;
						select cq.BusinessTypeId BusinessType,
							v.[GUID] VoucherGuid,
							v.ActivatedOn,
							v.[Status] VoucherStatus,
							v.ExpiryDate,
							p.ProductCode,
							REPLACE(p.ProductName, ''{FV}'', FORMAT(ISNULL(obi.FaceValueWithTax, 0) / 100.0,''0.##'')) ProductName,
							o.OrderName ProjectName,
							p.MultipleSelectionType
							from Voucher v with(nolock,forceseek)
							join OrderBeneficiaryInfo obi with(nolock) on v.BeneficiaryInfoId = obi.Id
							join OrderLine ol with(nolock) on obi.OrderLineId = ol.Id
							join [Order] o with(nolock) on ol.OrderId = o.Id
							join ClientQuotation cq with(nolock) on o.ClientQuotationId = cq.Id
							left join BusinessModel bm with(nolock) on bm.Id = cq.BusinessModelId
							join Product p with(nolock) on v.ProductId = p.Id
						where v.[Status] in(2,32)
							and v.ActivatedOn >= @startDate and v.ActivatedOn <=@endDate';
	
	if @Email is null or @Email = ''
		set @sql = @sql + ' and obi.Mobile = @Mobile'
	else
		set @sql = @sql + ' and obi.Email = @Email'

	if @BusinessTypes is not null
		set @sql = @sql + ' and cq.BusinessTypeId in('+@BusinessTypes+')'

	if @BusinessModelIds is not null
		set @sql = @sql + ' and bm.DisplayNameId in('+@BusinessModelIds+')'

	if @OrderName is not null
		set @sql = @sql + ' and o.OrderName like N''%'+@OrderName+'%'''

	if @ProductName is not null
		set @sql = @sql + ' and p.ProductName like N''%'+@ProductName+'%'''

	set @sql = @sql + ' order by v.Id offset (@PageSize * (@PageNumber-1)) rows fetch next @PageSize rows only;'
	
	exec sp_executesql @sql, 
		N'@Email varchar(50) = null,@Mobile varchar(50) = null,@startDate datetime,@endDate datetime,@PageNumber int,@PageSize int',
		@Email,@Mobile,@startDate,@endDate,@PageNumber,@PageSize;
END