CREATE PROCEDURE [dbo].[sp_ins_order_line]
	@OrderLineId int output,
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,

	@order_id int ,
	@quotation_product_id int ,
	@product_id int,
	@total_quantity int ,
	@email_quantity int ,
	@slms_quantity int ,
	@email_template_version_id int ,
	@slms_template_version_id int ,
	@default_expiration_date datetime ,
	@voucher_reservation_code_id int ,
	@need_short_url bit ,
	@status int ,
	@expiration_policy_id int ,
	@message_encoding nvarchar(25) ,
	@published_quantity int ,
	@ad_hoc_rule_product_id int ,
	@order_email_template_version_id int ,
	@order_slms_template_version_id int ,
	@need_trust_account bit ,
	@cancelled_quantity int,
	@child_order_line_id int
AS
BEGIN

	SET XACT_ABORT ON;

	BEGIN TRY

	    BEGIN TRANSACTION;
		
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;
		SET @OrderLineId = 0;

		DECLARE @created_id table (id int)

	    INSERT INTO tb_ol_order_line
		(
		[order_id],
		[quotation_product_id],
		[product_id],
		[total_quantity],
		[email_quantity],
		[slms_quantity],
		[email_template_version_id],
		[slms_template_version_id],
		[default_expiration_date],
		[voucher_reservation_code_id],
		[need_short_url],
		[status],
		[expiration_policy_id],
		[message_encoding],
		[published_quantity],
		[ad_hoc_rule_product_id],
		[order_email_template_version_id],
		[order_slms_template_version_id],
		[need_trust_account],
		[cancelled_quantity],
		[child_order_line_id]
		)
	OUTPUT INSERTED.id INTO @created_id
	VALUES
		(
			@order_id,
			@quotation_product_id,
			@product_id,
			@total_quantity,
			@email_quantity,
			@slms_quantity,
			@email_template_version_id,
			@slms_template_version_id,
			@default_expiration_date,
			@voucher_reservation_code_id,
			@need_short_url,
			@status,
			@expiration_policy_id,
			@message_encoding,
			@published_quantity,
			@ad_hoc_rule_product_id,
			@order_email_template_version_id,
			@order_slms_template_version_id,
			@need_trust_account,
			@cancelled_quantity,
			@child_order_line_id
		);

		IF @@ROWCOUNT > 0
			BEGIN
		SET @IsSuccess = 1;
		SELECT @OrderLineId = id
		FROM @created_id
	END
		ELSE
			BEGIN
		SET @ErrorMessage = 'failed to add order line';
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