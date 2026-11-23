
CREATE PROCEDURE spTryGetPartialVoucherSN
	@orderLineId int,
    @startOrderLineSN int,
	@endOrderLineSN int
AS
BEGIN
	SET NOCOUNT ON;

	declare @sessionId varchar(50) = (select top 1 SessionId from AdoraTask where OrderId = (select OrderId from OrderLine where Id = @orderLineId))

	if not exists(select 1 from VoucherOrderBatch where OrderLineId = @orderLineId and SessionId = @sessionId)
	begin
		select @startOrderLineSN startOrderLineSN, @endOrderLineSN endOrderLineSN;
		return;
	end

	declare @table table
	(
		Id int identity(1,1) primary key,
		StartId int,
		EndId int
	)

	insert @table(StartId,EndId) select OrderLineStartSN, OrderLineEndSN from VoucherOrderBatch where OrderLineId = @orderLineId AND SessionId = @sessionId order by OrderLineStartSN;

	declare @rowIndex int = 1;
	declare @rowCount int = (select count(1) from @table);
	declare @startId int = 1;
	declare @endId int = 1;
	declare @resultStartId int = 1;
	declare @resultEndId int = 0;
	while(@rowIndex <= @rowCount)
	begin
		select @startId = StartId, @endId = EndId from @table where Id = @rowIndex;
		if @endId < @startOrderLineSN
			set @resultStartId = @resultStartId + @endId - @startId + 1;
		else if @startId > @endOrderLineSN
			break;
		else
		begin
			if @startId < @startOrderLineSN	--此条件最多满足一次
			begin
				set @resultStartId = @resultStartId + @startOrderLineSN - @startId;
				set @resultEndId = @resultStartId + IIF(@endId > @endOrderLineSN, @endOrderLineSN, @endId) - @startOrderLineSN;
			end
			else
			begin
				if @resultEndId = 0
					set @resultEndId = @resultStartId - 1;
				set @resultEndId = @resultEndId + IIF(@endId > @endOrderLineSN, @endOrderLineSN, @endId) - @startId + 1;
			end
		end

		set @rowIndex += 1;
	end

	set @startOrderLineSN = @resultStartId;
	set @endOrderLineSN = @resultEndId;

	select @startOrderLineSN as startOrderLineSN, @endOrderLineSN as endOrderLineSN;
END
