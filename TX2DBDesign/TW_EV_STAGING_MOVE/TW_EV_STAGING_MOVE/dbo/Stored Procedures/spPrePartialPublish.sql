
create procedure spPrePartialPublish @orderLineId int,@stockCount int,@publishCount int output
as
BEGIN
	set nocount on;
	--已经处理过
	if exists(select 1 from VoucherOrderBatch where OrderLineId = @orderLineId and Assigned = 0)
	begin
		select @publishCount = sum(OrderLineEndSN - OrderLineStartSN + 1) from VoucherOrderBatch where OrderLineId = @orderLineId and Assigned = 0;
		return;
	end

	--返回列表
	declare @minQuantity int = (select min(VoucherQuantity) from OrderBeneficiaryInfo where OrderLineId = @orderLineId);
	declare @sessionId varchar(50) = (select top 1 SessionId from AdoraTask where OrderId = (select OrderId from OrderLine where Id = @orderLineId));

	if @stockCount < @minQuantity
	begin
		set @publishCount = 0;
	end
	else
	begin
		select DISTINCT vo.OrderId,vo.OrderLineSN,vo.OrderBeneficiaryInfoSN,@sessionId SessionId 
			FROM dbo.VoucherOrder vo WITH(NOLOCK)
			JOIN dbo.OrderBeneficiaryInfo obi WITH(NOLOCK) ON obi.Id = vo.OrderBeneficiaryInfoId AND obi.Status = 0
			WHERE vo.OrderLineId = @orderLineId and vo.VoucherId is NULL ORDER BY vo.OrderLineSN;
		IF @@ROWCOUNT > 0
			set @publishCount = -1;
		ELSE
			set @publishCount = 0;
	end
END
