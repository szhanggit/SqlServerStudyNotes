CREATE PROCEDURE [dbo].[sp_ins_gr_order_create_detail]
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,
	@RowCount int output,
	@GRClientOrderId dbo.tvp_gr_order_create_detail READONLY
AS 
BEGIN

	SET XACT_ABORT ON;

	BEGIN TRY

		BEGIN TRANSACTION;

		SET @IsSuccess = 0;
		SET @RowCount = 0;
		SET @ErrorMessage = null;

		INSERT INTO [dbo].[tb_gocd_gr_order_create_detail]
		(
		[client_order_id],
		[gr_order_id] ,
		[client_order_number] ,
		[program_name],
		[beneficiary_name] ,
		[awared_by] ,
		[email] ,
		[product_code] ,
		[quantity] ,
		[quotation_number] ,
		[publish_time] ,
		[expiry_date_type] ,
		[mobile] ,
		[expiry_date] ,
		[expiry_time] ,
		[memo] ,
		[reservation_code],
		[sub_program],		
		[Misc_1] ,
		[misc_2] ,
		[misc_3] ,
		[redemption_id],
		[status],
		[result]
		)
		SELECT
		[client_order_id],
			[gr_order_id] ,
		[client_order_number] ,
		[program_name],
		[beneficiary_name] ,
		[awared_by] ,
		[email] ,
		[product_code] ,
		[quantity] ,
		[quotation_number] ,
		[publish_time] ,
		[expiry_date_type] ,
		[mobile] ,
		[expiry_date] ,
		[expiry_time] ,
		[memo] ,
		[reservation_code],
		[sub_program],		
		[Misc_1] ,
		[misc_2] ,
		[misc_3] ,
		[redemption_id],
		[status],
		[result]
		FROM @GRClientOrderId

		
		SET @RowCount = @@ROWCOUNT;

		IF @RowCount > 0
			BEGIN				
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