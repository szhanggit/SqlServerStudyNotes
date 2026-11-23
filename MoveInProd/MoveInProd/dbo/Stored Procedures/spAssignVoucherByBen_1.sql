-- =============================================
-- Author:		Knight YAO
-- Create date: 2014/12/18
-- Description:	Assign voucher.
-- =============================================
CREATE PROCEDURE [dbo].[spAssignVoucherByBen]
	@OrderBeneficiaryInfoId		BIGINT,
	@ProductId					INT,
	@VoucherQuantity			INT,
	@IsSuccess					BIT		OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	BEGIN TRAN

	BEGIN TRY
		DECLARE @TopNumber	INT
		SELECT @TopNumber = @VoucherQuantity - COUNT(1)
		FROM [dbo].[Voucher]
		WHERE [BeneficiaryInfoId] = @OrderBeneficiaryInfoId

		DECLARE @VoucherReservationCodeId int

		select @VoucherReservationCodeId = ol.VoucherReservationCodeId
		from OrderBeneficiaryInfo b 
		  join OrderLine ol on b.OrderLineId = ol.Id
		where b.Id = @OrderBeneficiaryInfoId

		UPDATE TOP(@TopNumber) V
		SET [BeneficiaryInfoId] = @OrderBeneficiaryInfoId
		FROM [dbo].[Voucher] V
		inner join VoucherReservationBatch b on V.ReservationBatchId = b.Id
		inner join VoucherReservationCode c on b.VoucherReservationCodeId = c.Id
		WHERE [BeneficiaryInfoId] IS NULL 
		  AND v.[ProductId] = @ProductId 
		  AND v.[Status] = 64
		  AND c.Id = @VoucherReservationCodeId

		IF(@TopNumber<>@@ROWCOUNT)
		BEGIN
		  ROLLBACK TRANSACTION
		  SET @IsSuccess = 0
		  RETURN
		END

		SET @IsSuccess = 1
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		SET @IsSuccess = 0
		RETURN
	END CATCH

	COMMIT TRANSACTION
END

