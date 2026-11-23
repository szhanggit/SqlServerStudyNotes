create proc spCheckUserTrashVoucher @CSUserId int, @VoucherId bigint, @CSUserName varchar(20) output
as
begin
	set nocount on;

	declare @CSUserRole tinyint = null;
	select @CSUserRole = CSUserRole, @CSUserName = UserName from CSUser where Id = @CSUserId

	--未找到记录
	if @CSUserRole is null
	begin
		select 0;
		return;
	end

	--无Trash权限
	if @CSUserRole = 1
	begin
		select 1;
		return;
	end

	--有Trash权限
	if @CSUserRole = 2
	begin
		select 3;
		return;
	end

	--无Trash权限
	if @CSUserRole = 3
	begin
		select 1;
		return;
	end

	--受限的Trash权限
	if @CSUserRole = 4
	begin
		if exists(SELECT null FROM Voucher v WITH(NOLOCK)
				INNER JOIN OrderBeneficiaryInfo obi WITH(NOLOCK) ON v.BeneficiaryInfoId = obi.Id
				INNER JOIN OrderLine ol WITH(NOLOCK) ON obi.OrderLineId = ol.Id
				INNER JOIN [Order] o WITH(NOLOCK) ON ol.OrderId = o.Id
				INNER JOIN Product p WITH(NOLOCK) ON v.ProductId = p.Id
				INNER JOIN ClientQuotation cq WITH(NOLOCK) ON o.ClientQuotationId = cq.Id
				INNER JOIN Client c WITH(NOLOCK) ON cq.ClientId = c.Id
				INNER JOIN CSUserClient CC WITH(NOLOCK) ON C.Id = CC.ClientId
				INNER JOIN CSUser CSU WITH(NOLOCK) ON CC.CSUserId = CSU.Id
				LEFT JOIN CSUserClientQuotation CCQ WITH(NOLOCK) ON CCQ.CSUserId = CSU.Id
				WHERE CSU.Id = @CSUserId and v.Id = @VoucherId and ((CCQ.ID IS NULL) OR (CCQ.ID IS NOT NULL AND CCQ.QuotationId = CQ.Id)))
			select 3;
		else
			select 2;

		return;
	end
end
