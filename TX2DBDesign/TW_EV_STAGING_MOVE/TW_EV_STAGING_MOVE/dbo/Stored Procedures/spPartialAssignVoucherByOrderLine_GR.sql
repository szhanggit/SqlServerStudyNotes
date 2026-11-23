
CREATE PROCEDURE spPartialAssignVoucherByOrderLine_GR
	@OrderLineId	int
   ,@IsSuccess  bit output
AS
BEGIN

declare @ProductId as int
declare @VoucherReservationCodeId as int
declare @Number2Assign as int
declare @timecutline  as  datetime;
SET @timecutline = DATEADD(DAY, 14, getdate())

if not exists(select 1 from VoucherOrderBatch with(nolock) where OrderLineId = @OrderLineId and Assigned = 0) --already assigned
BEGIN
	select @IsSuccess = 1
	return
END
  
select @ProductId = -1,@VoucherReservationCodeId=-1

select @productid = pv.productid, @VoucherReservationCodeId=ol.VoucherReservationCodeId
from orderline ol join clientquotationproduct cqp on ol.clientquotationproductid = cqp.id
	    join productversion pv on cqp.productversionid = pv.id
where ol.id = @OrderLineId
    
select @Number2Assign = sum(OrderLineEndSN - OrderLineStartSN + 1) from VoucherOrderBatch where OrderLineId = @orderLineId and Assigned = 0;

if(isnull(@ProductId,-1)=-1 or isnull(@VoucherReservationCodeId,-1)=-1)
Begin
	set @IsSuccess= 0
	return
End

DECLARE @CurrentDate INT
SET @CurrentDate = CAST(convert(varchar,getdate(),112) as int)

BEGIN TRAN

BEGIN TRY
	declare @sessionId varchar(50) = (select top 1 SessionId from AdoraTask where OrderId = (select OrderId from OrderLine where Id = @orderLineId))

	update vt set vt.BeneficiaryInfoId = vo.OrderBeneficiaryInfoId,vt.VSessionId = @sessionId from
		(select voo.OrderBeneficiaryInfoId,ROW_NUMBER()OVER(Order By voo.OrderLineSN) OrderLineSN from voucherorder voo join VoucherOrderBatch b
			on voo.OrderLineSN between b.OrderLineStartSN and b.OrderLineEndSN and b.Assigned = 0 and voo.VoucherId is null and b.OrderLineId = @OrderLineId where voo.OrderLineId = @OrderLineId) vo join 
		(select ROW_NUMBER()OVER(Order By v.ExpiryDate)As OrderLineSN,BeneficiaryInfoId,VSessionId
			from voucher v WITH (READPAST) join voucherreservationbatch vrb on v.ReservationBatchId = vrb.id
			where v.productid=@ProductId
			    and v.status = 64 
				and v.BeneficiaryInfoId is null
				and vrb.VoucherReservationCodeId = @VoucherReservationCodeId
				and (v.ExpiryDate >= @timecutline or v.ExpiryDate IS NULL)
				AND @CurrentDate >= vrb.AvailableStartDate
				AND vrb.AvailableEndDate >= @CurrentDate
			) vt on vo.OrderLineSN = vt.OrderLineSN

	if(@@ROWCOUNT<>@Number2Assign)
	begin
		set @IsSuccess = 0
		rollback TRANSACTION
		return
	end

	update vo
	set vo.VoucherId = vt.Id
	from voucherorder vo join 
		    (select ROW_NUMBER()OVER(Partition By v.BeneficiaryInfoId Order By v.id)As OrderBeneficiaryInfoSN, 
			        BeneficiaryInfoId,
					Id
			from voucher v WITH (READPAST)
			    join (select distinct OrderBeneficiaryInfoId from voucherorder where orderlineid = @OrderLineId) vot on v.BeneficiaryInfoId = vot.OrderBeneficiaryInfoId
			) vt on vo.OrderBeneficiaryInfoId = vt.BeneficiaryInfoId and vo.OrderBeneficiaryInfoSN = vt.OrderBeneficiaryInfoSN and vo.VoucherId is null
		where vo.OrderLineId = @OrderLineId

	if(@@ROWCOUNT<>@Number2Assign)
	begin
		set @IsSuccess = 0
		rollback TRANSACTION
		return
	end

	update VoucherOrderBatch set Assigned = 1 where OrderLineId = @OrderLineId;
	update OrderLine set PublishedQuantity = PublishedQuantity + @Number2Assign where Id = @OrderLineId;

	set @IsSuccess = 1

END TRY
BEGIN CATCH
	set @IsSuccess = 0
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
	return
END CATCH;

IF @@TRANCOUNT > 0
	COMMIT TRANSACTION;
END
