create proc spQueryProcessDetail @ProcessLogId int, @result int output
as
begin
	set nocount on;

	declare @OrderGroupId int;
	declare @OrderId int;
	declare @SessionId varchar(50);

	select @OrderGroupId = OrderGroupId, @SessionId = SessionId from ProcessLog with(nolock) where Id = @ProcessLogId

	--多条记录
	--1.检查OrderGroup中具有该SessionId的Order是否都已经执行成功
	----1.1 检查Order状态,非Publishing且非ToPublish状态的一定执行成功了。
	----1.2 检查Order对应的SessionId是否一致
	--2.如果OrderGroup已经执行完毕
	----2.1 检查Order的SessionId是否为之前的，如果是则表示该Order本次没有处理
	----2.2 剩下的就是本次执行成功的。
	begin
		declare @table1 table
		(
			OrderId1 int not null,
			OrderStatus int,
			ExecutingStatus int,
			isEnd bit,
			isFail bit
		);

		insert @table1(OrderId1,OrderStatus,ExecutingStatus,isEnd,isFail)
				select Id, [Status] ,ExecutingStatus, 0, 0 from [Order] with(nolock) 
					where OrderGroupId = @OrderGroupId and ([Status] = 32 or [Status] = 512 or [Status] = 8 or [Status] = 16)

		if exists(select 1 from @table1 where OrderStatus = 512 or OrderStatus = 8 or OrderStatus = 16)
		begin
			set @result = 0;
			return;
		end

		update @table1 set isEnd = 1 where exists(select 1 from AdoraTask with(nolock) where OrderId = OrderId1 and SessionId != @SessionId);
		update @table1 set isFail = 1 where isEnd =0 and OrderStatus = 32 and (ExecutingStatus = 3 or ExecutingStatus = 5 or ExecutingStatus = 7 or ExecutingStatus = 10)

		if exists(select 1 from @table1 where isEnd = 0 and isFail = 0)
		begin
			set @result = 0;
			return;
		end

		if exists(select 1 from @table1 where isFail = 1)
		begin
			set @result = 2;
			select OrderNumber from [Order] with(nolock) where Id in(select OrderId1 from @table1 where isFail = 1)
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

		update @table2 set NeedQuery = 0 where exists
			(select 1 from AdoraTask with(nolock) where OrderId = OrderId2 
				and SessionId in(select SessionId from ProcessLog where Id < @ProcessLogId and OrderGroupId = @OrderGroupId))

		select  ext.GROrderID RAS_Redemption_ID,
				ext.Misc2 Country_Name,
				obi.ClientOrderNumber Redemption_Confirmation_No,
				obi.Name [User_Name],
				p.ProductCode Redemption_Item_SKU,
				'email' Consignment_Note_Number,
				'' Pr_Number,
				CONVERT(varchar(20),obi.ActiveDate, 101) Date_of_Shipment,
				'' Shipment_Method,
				'email' Ship_By,
				'' Item_Handled_By,
				'' Item_Handled_Date,
				'' Voucher_Serial_No,
				'' PO_Number,
				'' POD_Ref_Number,
				'' Item_Received_by,
				'' Item_Received_Date,
				'' Postage_Surcharge,
				'' Remarks
			from [Order] o with(nolock)
				join OrderLine ol with(nolock) on o.Id = ol.OrderId
				join OrderBeneficiaryInfo obi with(nolock) on ol.Id = obi.OrderLineId
				join ProductVersion pv with(nolock) on pv.Id = obi.ProductVersionId
				join Product p with(nolock) on p.Id = pv.ProductId
				join EXT_GR_OrderBeneficiaryInfo ext with(nolock) on ext.Id = obi.Id
			where o.Id in(select OrderId2 from @table2 where NeedQuery = 1) 
				and exists(select null from Voucher with(nolock) where BeneficiaryInfoId = obi.Id and VSessionId = @SessionId);
		
		set @result = 1;
	end
end
