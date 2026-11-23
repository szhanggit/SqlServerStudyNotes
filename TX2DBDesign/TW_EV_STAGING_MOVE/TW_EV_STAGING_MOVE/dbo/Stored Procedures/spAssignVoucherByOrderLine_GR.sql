-- =============================================
-- Author:		Eagls WANG
-- Create date: 2017/05/18
-- Description:	Assign Voucher By Order Line FOR GR
-- =============================================
CREATE PROCEDURE spAssignVoucherByOrderLine_GR
	@OrderLineId	int
   ,@IsSuccess  bit output
AS
BEGIN

	declare @ProductId as int
	declare @VoucherReservationCodeId as int
	declare @Number2Assign as int
	declare @timecutline  as  datetime;
    SET @timecutline = DATEADD(DAY, 14, getdate())

  if(exists(select 1 from voucherorder where OrderLineId=@OrderLineId and voucherid is not null)) --already assigned
  BEGIN
    select @IsSuccess = 1
    return
  END
  
	select @ProductId = -1,@VoucherReservationCodeId=-1

	select @productid = pv.productid, @VoucherReservationCodeId=ol.VoucherReservationCodeId
	from orderline ol join clientquotationproduct cqp on ol.clientquotationproductid = cqp.id
	     join productversion pv on cqp.productversionid = pv.id
    where ol.id = @OrderLineId
    
	select @Number2Assign = count(*) from VoucherOrder where OrderLineId = @OrderLineId

	if(isnull(@ProductId,-1)=-1 or isnull(@VoucherReservationCodeId,-1)=-1)
	Begin
	  set @IsSuccess= 0
	  return
	End

	DECLARE @CurrentDate INT
	SET @CurrentDate = CAST(convert(varchar,getdate(),112) as int)

	BEGIN TRAN

	BEGIN TRY
		
		update vt
		set vt.BeneficiaryInfoId = vo.OrderBeneficiaryInfoId
		from voucherorder vo join 
		     (select ROW_NUMBER()OVER(Order By v.ExpiryDate)As OrderLineSN, 
			         BeneficiaryInfoId
			  from voucher v WITH (READPAST) join voucherreservationbatch vrb on v.ReservationBatchId = vrb.id
			  where v.productid=@ProductId
			      and v.status = 64 
				  and v.BeneficiaryInfoId is null
				  and vrb.VoucherReservationCodeId = @VoucherReservationCodeId
				  and (v.ExpiryDate >= @timecutline or v.ExpiryDate IS NULL)
				  AND @CurrentDate >= vrb.AvailableStartDate
				  AND vrb.AvailableEndDate >= @CurrentDate
			  ) vt on vo.OrderLineSN = vt.OrderLineSN
		 where vo.OrderLineId = @OrderLineId

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
			  ) vt on vo.OrderBeneficiaryInfoId = vt.BeneficiaryInfoId and vo.OrderBeneficiaryInfoSN = vt.OrderBeneficiaryInfoSN
		 where vo.OrderLineId = @OrderLineId

		 if(@@ROWCOUNT<>@Number2Assign)
		 begin
		    set @IsSuccess = 0
			rollback TRANSACTION
			return
		 end

		 update OrderLine set PublishedQuantity = TotalQuantity where Id = @OrderLineId;

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
