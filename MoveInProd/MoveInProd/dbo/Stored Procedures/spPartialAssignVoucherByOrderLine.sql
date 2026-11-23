-- =============================================
-- Author:		Knight YAO
-- Create date: 2016/06/15
-- Description:	Assign Voucher By Order Line
-- =============================================
CREATE PROCEDURE spPartialAssignVoucherByOrderLine
	@OrderLineId	INT,
    @IsSuccess  bit output
AS
BEGIN

declare @ProductId as int
declare @VoucherReservationCodeId as int
declare @Number2Assign as int

DECLARE @CurrentDateTime DATETIME = GETDATE()

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

declare @orderLineTrustAccountId int = (select top 1 id from OrderLineTrustAccount WHERE OrderLineId = @OrderLineId AND ValidFrom <= @CurrentDateTime AND ValidTo >= @CurrentDateTime ORDER BY Id DESC)
declare @bSessionId varchar(50) = NEWID()

DECLARE @CurrentDate INT
SET @CurrentDate = CAST(convert(varchar,getdate(),112) as int)

BEGIN TRAN
BEGIN TRY
	declare @sessionId varchar(50) = (select top 1 SessionId from AdoraTask where OrderId = (select OrderId from OrderLine where Id = @OrderLineId))
	declare @vSessionId varchar(50) = (select top 1 SessionId  from VoucherStockBook where OrderLineId = @OrderLineId order by Id desc)

	UPDATE vo set vo.VoucherId = vt.Id
		from (select voo.VoucherId,ROW_NUMBER()OVER(Order By voo.OrderLineSN) OrderLineSN from voucherorder voo join VoucherOrderBatch b
				on voo.OrderLineId = b.OrderLineId and voo.OrderLineSN between b.OrderLineStartSN and b.OrderLineEndSN 
				where b.Assigned = 0 and b.OrderLineId = @OrderLineId ) vo join 
			(select Id, ROW_NUMBER()OVER(Order By v.id)As OrderLineSN from voucher v
				where v.BeneficiaryInfoId is null and v.VSessionId = @vSessionId) vt on vo.OrderLineSN = vt.OrderLineSN

	if(@@ROWCOUNT<>@Number2Assign)
	begin
		set @IsSuccess = 0
		rollback TRANSACTION
		return
	end

	UPDATE vt set vt.BeneficiaryInfoId = vo.OrderBeneficiaryInfoId,vt.VSessionId = @sessionId
		from (select voo.OrderBeneficiaryInfoId,ROW_NUMBER()OVER(Order By voo.OrderLineSN) OrderLineSN from voucherorder voo join VoucherOrderBatch b
				on voo.OrderLineId = b.OrderLineId and voo.OrderLineSN between b.OrderLineStartSN and b.OrderLineEndSN 
				where b.Assigned = 0 and b.OrderLineId = @OrderLineId) vo join 
			(select ROW_NUMBER()OVER(Order By v.id)As OrderLineSN, BeneficiaryInfoId, VSessionId from voucher v
				where v.BeneficiaryInfoId is null and v.VSessionId = @vSessionId) vt on vo.OrderLineSN = vt.OrderLineSN

	if(@@ROWCOUNT<>@Number2Assign)
	begin
		set @IsSuccess = 0
		rollback TRANSACTION
		return
	end
	
	UPDATE obi SET obi.[Status] = 1
		FROM dbo.OrderBeneficiaryInfo obi
		JOIN dbo.Voucher v WITH(NOLOCK) ON v.BeneficiaryInfoId = obi.Id
		WHERE obi.OrderLineId = @OrderLineId AND obi.[Status] = 0

	IF @orderLineTrustAccountId IS NOT NULL
	BEGIN
		INSERT INTO VoucherTrustAccountBuffer (VoucherId, OrderLineTrustAccountId, SessionId)
		SELECT VoucherId, @orderLineTrustAccountId, @bSessionId
		FROM VoucherOrder WHERE OrderLineId = @OrderLineId
	END

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
