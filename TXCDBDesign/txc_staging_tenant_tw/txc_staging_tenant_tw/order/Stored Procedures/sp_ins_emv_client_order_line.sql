CREATE PROCEDURE [order].[sp_ins_emv_client_order_line]
	@IsSuccess int output,
	@ErrorMessage nvarchar(250) output,
	@RowCount int output,
	@EMVClientOrderLines dbo.tvp_emv_client_order_line READONLY
AS 
BEGIN

	SET XACT_ABORT ON;

	BEGIN TRY

		BEGIN TRANSACTION;

		SET @IsSuccess = 0;
		SET @RowCount = 0;
		SET @ErrorMessage = null;

		INSERT INTO tb_ecol_emv_client_order_line
		(
			emv_client_order_id ,
			quotation_product_id ,
			program_name ,
			program_id ,
			local_redemption_id ,
			user_id ,
			user_name ,
			first_name ,
			middle_name ,
			last_name ,
			email ,
			contact_phone ,
			country ,
			redemption_date ,
			rcn ,
			redemption_item_name ,
			sku ,
			quantity ,
			unitItem_points ,
			totalItem_points ,
			delivery_type ,
			delivery_priority ,
			client_order_number ,
			priority ,
			remarks ,
			client_sku_code ,
			flex1 ,
			flex2 ,
			flex3 ,
			flex4 ,
			flex5 ,
			status ,
			created_time ,
			updated_time ,
			order_number ,
			result
		)
		SELECT
			emv_client_order_id ,
			quotation_product_id ,
			program_name ,
			program_id ,
			local_redemption_id ,
			user_id ,
			user_name ,
			first_name ,
			middle_name ,
			last_name ,
			email ,
			contact_phone ,
			country ,
			redemption_date ,
			rcn ,
			redemption_item_name ,
			sku ,
			quantity ,
			unitItem_points ,
			totalItem_points ,
			delivery_type ,
			delivery_priority ,
			client_order_number ,
			priority ,
			remarks ,
			client_sku_code ,
			flex1 ,
			flex2 ,
			flex3 ,
			flex4 ,
			flex5 ,
			status ,
			created_time ,
			updated_time ,
			order_number ,
			result
		FROM @EMVClientOrderLines

		INSERT INTO tb_eco_emv_rcn_key
		(
			rcn
		)
		Select rcn FROM @EMVClientOrderLines where status = 0


		IF @@ROWCOUNT > 0
			BEGIN
				SET @RowCount = @@ROWCOUNT;
				SET @IsSuccess = 1;
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to add emv client order line';
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