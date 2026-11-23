create proc spQueryProcessFail @ProcessLogId int, @result int output
as
begin
	set nocount on;

	declare @OrderGroupId int;
	declare @SessionId varchar(50);

	select @OrderGroupId = OrderGroupId, @SessionId = SessionId from ProcessLog with(nolock) where Id = @ProcessLogId

	--1.检查OrderGroup中具有该SessionId的Order是否都已经执行完，执行完才会进行统计
	----1.1 检查Order状态,非publishing的一定执行成功了。
	----1.2 检查Order对应的SessionId是否改变了，如果改变了，一定执行成功了。
	declare @table1 table
	(
		OrderId1 int not null,
		isEnd bit
	);

	insert @table1(OrderId1,isEnd)
			select Id, 0 from [Order] with(nolock) 
				where OrderGroupId = @OrderGroupId and ([Status] = 32 or [Status] = 512 or [Status] = 8 or [Status] = 16)
	update @table1 set isEnd = 1 where exists(select 1 from AdoraTask with(nolock) where OrderId = OrderId1 and SessionId != @SessionId);

	if exists(select 1 from @table1 where isEnd = 0)
	begin
		set @result = 0
		return;
	end

	declare @table2 table
	(
		Id int identity(1,1),
		OrderId2 int not null,
		OrderStatus int,
		ExecutingStatus int,
		NeedQuery bit
	);

	insert @table2(OrderId2,OrderStatus,ExecutingStatus,NeedQuery)
			select Id, [Status], ExecutingStatus, 1 from [Order] with(nolock) 
				where OrderGroupId = @OrderGroupId and ([Status] = 32 or [Status] = 64 or [Status] = 256 or [Status] = 512) order by Id;

	update @table2 set NeedQuery = 0 where OrderStatus = 64 and exists
		(select 1 from AdoraTask with(nolock) where OrderId = OrderId2 and SessionId = @SessionId);
	
	create table #table3
	(
		Id int identity(1,1) primary key,
		GROrderID nvarchar(50) null,
		ProgramId int not null,
		ProductId int not null,
		ProductCode varchar(50) not null,
		Insufficient int,
		InStock int,
		NeedBuy int
	);

	insert #table3(GROrderID,ProgramId,ProductId,ProductCode,Insufficient)
	select	ext.GROrderID,
			(select ProgramId from Product where Id = p.Id) ProgramId,
			p.Id,
			(select ProductCode from Product where Id = p.Id) ProductCode,
			count(1) Insufficient
		from [Order] o with(nolock)
			join OrderLine ol with(nolock) on o.Id = ol.OrderId
			join OrderBeneficiaryInfo obi with(nolock) on ol.Id = obi.OrderLineId
			join ProductVersion pv with(nolock) on pv.Id = obi.ProductVersionId
			join Product p with(nolock) on p.Id = pv.ProductId
			join VoucherOrder vo with(nolock) on vo.OrderBeneficiaryInfoId = obi.Id
			join EXT_GR_OrderBeneficiaryInfo ext with(nolock) on ext.Id = obi.Id
			left join Voucher v with(nolock) on v.Id = vo.VoucherId and VSessionId = @SessionId
		where o.Id in (select OrderId2 from @table2 where NeedQuery = 1)
			and v.VSessionId is null
			--not exists(select null from Voucher with(nolock) where Id = vo.VoucherId and VSessionId = @SessionId)
		group by p.Id,ext.GROrderID;

	declare @index int = 1;
	declare @totalCount int = (select count(1) from #table3);
	declare @tableName varchar(50);
	declare @sql varchar(2000);
	while @index <= @totalCount
	begin
		set @tableName = (select VoucherStockTableName from ProgramVoucherRoute where ProgramId = (select ProgramId from #table3 where Id = @index));
		set @sql = 'update #table3 set InStock = (select count(1) from VoucherStock with(nolock) where StockStatus = 0 and ProductId = (select ProductId from #table3 where Id = @index))
			where Id = @index;';
		set @sql = REPLACE(@sql,'@index',@index);
		set @sql = REPLACE(@sql,'@index',@index);
		set @sql = REPLACE(@sql,'VoucherStock',@tableName);
		exec(@sql);

		set @index += 1;
	end

	update #table3 set NeedBuy = IIF(Insufficient - InStock > 0, Insufficient - InStock, 0);

	select GROrderID,ProductCode,Insufficient,InStock,NeedBuy from #table3;

	truncate table #table3;
	drop table #table3;

	set @result = 1;
end
