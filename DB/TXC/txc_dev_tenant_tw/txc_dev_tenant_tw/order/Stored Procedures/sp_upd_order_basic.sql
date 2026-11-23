CREATE PROCEDURE [order].[sp_upd_order_basic]
	@OrderId int output,
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,

		@id int ,
		@mode int ,
		@is_direct_delivery bit ,
		@publish_datetime datetime ,
		@status int ,
		@executing_status int ,
		@executing_response nvarchar(50) ,
		@updated_by nvarchar(50),
		@package_receiver nvarchar(100) ,
		@package_password nvarchar(20) ,
		@package_pin_receiver nvarchar(100) ,
		@order_name nvarchar(200) ,
		@short_url_auth_code_generation_way int ,
		@order_group_id int ,
		@indirect_file_format int ,
		@export_barcode_info int ,
		@voucher_supplier_id int ,
		@voucher_supplier_order_number nvarchar(50) ,
		@voucher_supplier_quotation_number nvarchar(50) ,
		@email_attach_short_url_image_id int ,
		@url_type int ,
		@generate_sequence_number bit ,
		@memo nvarchar(2000) ,
		@needed_preIssue bit ,
		@wallet_slms_template_id int ,
		@email_template_id int ,
		@slms_template_id int ,
		@MWV_email_template_id int,
		@email_tag_value_set_id int,
		@slms_tag_value_set_id int
AS
BEGIN
    
	SET XACT_ABORT ON;

	BEGIN TRY

	    BEGIN TRANSACTION;
		
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;
		SET @OrderId = @id;

	    update tb_ob_order_basic set
				mode  =		@mode  ,
		is_direct_delivery  =		@is_direct_delivery  ,
		publish_datetime  =		@publish_datetime  ,
		executing_status  =		@executing_status  ,
		executing_response  =		@executing_response  ,
		package_receiver  =		@package_receiver  ,
		package_password  =		@package_password  ,
		package_pin_receiver  =		@package_pin_receiver  ,
		order_name  =		@order_name  ,
		short_url_auth_code_generation_way  =		@short_url_auth_code_generation_way  ,
		order_group_id  =		@order_group_id  ,
		indirect_file_format  =		@indirect_file_format  ,
		export_barcode_info  =		@export_barcode_info  ,
		voucher_supplier_id  =		@voucher_supplier_id  ,
		voucher_supplier_order_number  =		@voucher_supplier_order_number  ,
		voucher_supplier_quotation_number  =		@voucher_supplier_quotation_number  ,
		email_attach_short_url_image_id  =		@email_attach_short_url_image_id  ,
		url_type  =		@url_type  ,
		generate_sequence_number  =		@generate_sequence_number  ,
		memo  =		@memo  ,
		needed_preIssue  =		@needed_preIssue  ,
		wallet_slms_template_id  =		@wallet_slms_template_id  ,
		email_template_id  =		@email_template_id  ,
		slms_template_id  =		@slms_template_id  ,
		MWV_email_template_id  =		@MWV_email_template_id  ,
		updated_by  =		@updated_by  ,
		updated_on = GETUTCDATE(),
		email_tag_value_set_id = @email_tag_value_set_id,
		slms_tag_value_set_id = @slms_tag_value_set_id
		where id = @id

		IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to update order basic';
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