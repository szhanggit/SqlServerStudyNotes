CREATE PROCEDURE [order].[sp_upd_order_line]
	@OrderLineId int output,
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,

	@id int,
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
	@cancelled_quantity int
AS
BEGIN

	SET XACT_ABORT ON;

	BEGIN TRY

	    BEGIN TRANSACTION;
		
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;
		SET @OrderLineId = @id;

	    update tb_ol_order_line set
		[total_quantity]=		@total_quantity,
		[email_quantity]=		@email_quantity,
		[slms_quantity]=		@slms_quantity,
		[email_template_version_id]=		@email_template_version_id,
		[slms_template_version_id]=		@slms_template_version_id,
		[default_expiration_date]=		@default_expiration_date,
		[voucher_reservation_code_id]=		@voucher_reservation_code_id,
		[need_short_url]=		@need_short_url,
		[status]=		@status,
		[expiration_policy_id]=		@expiration_policy_id,
		[message_encoding]=		@message_encoding,
		[published_quantity]=		@published_quantity,
		[ad_hoc_rule_product_id]=		@ad_hoc_rule_product_id,
		[order_email_template_version_id]=		@order_email_template_version_id,
		[order_slms_template_version_id]=		@order_slms_template_version_id,
		[need_trust_account]=		@need_trust_account,
		[cancelled_quantity]=		@cancelled_quantity
		where id = @id
		
		IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to update order line';
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