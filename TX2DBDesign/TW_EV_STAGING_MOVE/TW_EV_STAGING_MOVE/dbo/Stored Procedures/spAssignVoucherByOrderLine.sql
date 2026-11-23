-- =============================================
-- Author:		Knight YAO
-- Create date: 2016/06/15
-- Description:	Assign Voucher By Order Line
-- =============================================
CREATE PROCEDURE spAssignVoucherByOrderLine
	@OrderLineId	INT,
    @IsSuccess  bit output
AS
BEGIN
	set nocount on;
	declare @ProductId as int
	declare @VoucherReservationCodeId as int

	if(not exists(select 1 from voucherorder with(nolock) where OrderLineId=@OrderLineId and voucherid is null)) --already assigned
	BEGIN
		select @IsSuccess = 1
		return
	END
  
	select @ProductId = -1,@VoucherReservationCodeId=-1

	select @productid = pv.productid, @VoucherReservationCodeId=ol.VoucherReservationCodeId
	from orderline ol with(nolock) 
		join clientquotationproduct cqp with(nolock) on ol.clientquotationproductid = cqp.id
	    join productversion pv with(nolock) on cqp.productversionid = pv.id
    where ol.id = @OrderLineId

	if(isnull(@ProductId,-1)=-1 or isnull(@VoucherReservationCodeId,-1)=-1)
	Begin
	  set @IsSuccess= 0
	  return
	End

	DECLARE @CurrentDateTime DATETIME = GETDATE()

	declare @sessionId varchar(50) = (select top 1 SessionId from AdoraTask with(nolock) where OrderId = (select OrderId from OrderLine where Id = @orderLineId))
	declare @vSessionId varchar(50) = (select top 1 SessionId  from VoucherStockBook with(nolock) where OrderLineId = @OrderLineId order by Id desc)
	declare @totalCount int = (select max(OrderLineSN) from VoucherOrder with(nolock) where OrderLineId = @OrderLineId);
	declare @startId int = (select min(OrderLineSN) from VoucherOrder with(nolock) where OrderLineId = @OrderLineId and VoucherId is null);
	declare @endId int = 0;
	declare @step int = 3000;
	declare @orderLineTrustAccountId int = (select top 1 id from OrderLineTrustAccount with(nolock) WHERE OrderLineId = @OrderLineId AND ValidFrom <= @CurrentDateTime AND ValidTo >= @CurrentDateTime ORDER BY Id DESC)
	declare @bSessionId varchar(50) = NEWID()

	while @startId <= @totalCount
	begin
		BEGIN TRY
		BEGIN TRAN
			set @endId = @startId + @step - 1;
			if @endId > @totalCount
				set @endId = @totalCount;

			update vo set vo.VoucherId = vt.Id
				from voucherorder vo join 
					(select Id, ROW_NUMBER()OVER(Order By v.id) + @startId - 1 As OrderLineSN
					from voucher v where v.BeneficiaryInfoId is null and  v.VSessionId = @vSessionId
					) vt on vo.OrderLineSN = vt.OrderLineSN and vt.OrderLineSN >= @startId and vt.OrderLineSN <= @endId
				where vo.OrderLineId = @OrderLineId

			if(@@ROWCOUNT<>(@endId - @startId + 1))
			begin
				set @IsSuccess = 0
				rollback TRANSACTION
				return
			end

			UPDATE vt set vt.BeneficiaryInfoId = vo.OrderBeneficiaryInfoId, vt.VSessionId = @sessionId
				from voucherorder vo join 
						(select ROW_NUMBER()OVER(Order By v.id) + @startId - 1 As OrderLineSN, BeneficiaryInfoId, VSessionId
						from voucher v  where v.BeneficiaryInfoId is null and  v.VSessionId = @vSessionId
						) vt on vo.OrderLineSN = vt.OrderLineSN and vt.OrderLineSN >= @startId and vt.OrderLineSN <= @endId
				where vo.OrderLineId = @OrderLineId

			if(@@ROWCOUNT<>(@endId - @startId + 1))
			begin
				set @IsSuccess = 0
				rollback TRANSACTION
				return
			end
			
			if @endId = @totalCount
			begin
				update OrderLine set PublishedQuantity = TotalQuantity where Id = @OrderLineId;
				IF @orderLineTrustAccountId IS NOT NULL
				BEGIN
					INSERT INTO VoucherTrustAccountBuffer (VoucherId, OrderLineTrustAccountId, SessionId)
						SELECT VoucherId, @orderLineTrustAccountId, @bSessionId
						FROM VoucherOrder with(nolock) WHERE OrderLineId = @OrderLineId
				END
				set @IsSuccess = 1
			end
			
			UPDATE obi SET obi.[Status] = 1
				FROM dbo.OrderBeneficiaryInfo obi with(nolock)
				JOIN dbo.Voucher v WITH(NOLOCK) ON v.BeneficiaryInfoId = obi.Id
				WHERE obi.OrderLineId = @OrderLineId AND obi.[Status] = 0

			set @startId = @endId + 1;

		END TRY
		BEGIN CATCH
			set @IsSuccess = 0
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION
			return
		END CATCH;

		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;
	end
END
