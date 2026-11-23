
CREATE PROCEDURE spAssignVoucherBufferByOrderLine
	@OrderLineId	INT,
    @IsSuccess  bit output
AS
BEGIN
	SET NOCOUNT ON;

	--check assign
	DECLARE @UNPublishedQuantity INT = 0;
	select @UNPublishedQuantity = TotalQuantity - PublishedQuantity from dbo.OrderLine WITH(NOLOCK) WHERE Id = @OrderLineId;
	if @UNPublishedQuantity = 0
	BEGIN
		select @IsSuccess = 1
		return
	END
  
	--check Product
	DECLARE @TotalCount INT; 
	DECLARE @ProductId INT = NULL;
	DECLARE @VoucherReservationCodeId INT = NULL;

	SELECT	@productid = pv.productid, 
			@TotalCount = ol.TotalQuantity,
			@VoucherReservationCodeId = ol.VoucherReservationCodeId
		FROM dbo.OrderLine ol 
		JOIN dbo.ClientQuotationProduct cqp on ol.clientquotationproductid = cqp.id
	    join dbo.ProductVersion pv on cqp.productversionid = pv.id
		WHERE ol.id = @OrderLineId

	if(@ProductId IS NULL OR @VoucherReservationCodeId IS NULL)
	Begin
	  set @IsSuccess= 0
	  return
	End

	DECLARE @sessionId varchar(50) = 
		(select top (1) SessionId from dbo.AdoraTask where OrderId = (select OrderId from dbo.OrderLine where Id = @orderLineId))
	
	BEGIN TRAN
	BEGIN TRY
		UPDATE vo SET vo.VoucherId = vt.Id, vo.SessionId = @sessionId, vo.VoucherNumber = vt.VoucherNumber
			FROM dbo.VoucherOrderBuffer vo
			JOIN(SELECT Id, VoucherNumber, ROW_NUMBER() OVER(ORDER BY Id) OrderLineSN FROM dbo.VoucherBuffer WHERE OrderLineId = @OrderLineId)vt 
				ON vo.OrderLineSN = vt.OrderLineSN
			WHERE vo.OrderLineId = @OrderLineId;

		if(@@ROWCOUNT <> @totalCount)
		begin
			set @IsSuccess = 0
			ROLLBACK;
			RETURN;
		end

		UPDATE v SET v.BeneficiaryInfoId = vo.OrderBeneficiaryInfoId, v.VSessionId = @sessionId
			FROM dbo.VoucherOrderBuffer vo
			JOIN dbo.VoucherBuffer v ON v.Id = vo.VoucherId
			WHERE v.OrderLineId = @OrderLineId AND vo.OrderLineId = @OrderLineId;

		if(@@ROWCOUNT <> @totalCount)
		begin
			set @IsSuccess = 0
			ROLLBACK;
			RETURN;
		end
			
		update dbo.OrderLine set PublishedQuantity = TotalQuantity where Id = @OrderLineId;

		COMMIT;
		set @IsSuccess = 1
	END TRY
	BEGIN CATCH
		ROLLBACK
		set @IsSuccess = 0;
	END CATCH;
END
