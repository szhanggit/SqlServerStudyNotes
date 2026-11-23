CREATE PROCEDURE [order].[sp_ins_order_beneficiary_info]
	@IsSuccess int output,
	@ErrorMessage nvarchar(250) output,
	@ObiCount int output,
	@OrderBeneficiaryInfos dbo.tvp_ins_multiple_obi READONLY
AS 
BEGIN

	SET XACT_ABORT ON;

	BEGIN TRY

		BEGIN TRANSACTION;

		SET @IsSuccess = 0;
		SET @ObiCount = 0;
		SET @ErrorMessage = null;

		INSERT INTO tb_obi_order_beneficiary_info
		(
			order_line_id,
			mobile,
			email,
			voucher_quantity,
			active_date,
			expiry_scheme_id,
			expiry_date,
			client_order_number,
			memo,
			name,
			address,
			post_code,
			ED_order_number,
			member_id,
			language_id,
			status,
			face_value,
			face_value_with_tax,
			sold_price,
			sold_price_with_tax
		)
		SELECT
			OrderLineId,
			Mobile,
			Email,
			VoucherQuantity,
			ActiveDate,
			ExpirySchemeId,
			ExpiryDate,
			ClientOrderNumber,
			Memo,
			Name,
			Address,
			PostCode,
			EDOrderNumber,
			MemberId,
			LanguageId,
			Status,
			FaceValue,
			FaceValueWithTax,
			SoldPrice,
			SoldPriceWithTax
		FROM @OrderBeneficiaryInfos


		IF @@ROWCOUNT > 0
			BEGIN
				SET @ObiCount = @@ROWCOUNT;
				SET @IsSuccess = 1;
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to add order beneficiary infos';
			END

		IF @IsSuccess = 0
			BEGIN
				ROLLBACK TRANSACTION;
			END
		ELSE
			BEGIN
				COMMIT TRANSACTION;
			END

	END TRY
	
	BEGIN CATCH
		IF @@ROWCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION
			END;

		THROW;

	END CATCH

	SET NOCOUNT, XACT_ABORT OFF;

END