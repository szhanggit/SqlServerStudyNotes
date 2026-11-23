CREATE PROCEDURE [order].[sp_upd_order_template_info]
	@OrderId int output,
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,

	@order_id int,
	@email_tag_value_set_id int ,
	@slms_tag_value_set_id int ,
	@email_template_id int, 
	@slms_template_id int, 
	@MWV_email_template_id int
AS
BEGIN
    
	SET XACT_ABORT ON;

	BEGIN TRY

	    BEGIN TRANSACTION;
		
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;
		SET @OrderId = @order_id;

	    update tb_ob_order_basic set
				email_tag_value_set_id  =		@email_tag_value_set_id  ,
				slms_tag_value_set_id = @slms_tag_value_set_id,
				email_template_id = @email_template_id,
				slms_template_id = @slms_template_id,
				MWV_email_template_id = @MWV_email_template_id
		where id = @order_id

		IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to update order activate mode';
			END

		stop_process:

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
       IF @@TRANCOUNT > 0
       BEGIN
          ROLLBACK TRANSACTION
       END;

	   THROW;
	END CATCH

	SET NOCOUNT, XACT_ABORT OFF;

END