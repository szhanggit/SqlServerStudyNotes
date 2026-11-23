CREATE PROCEDURE [product].[sp_upd_product]
	@product_id INT
	,@external_product_code VARCHAR(50)
	,@brand_id INT = NULL
	,@sku_id INT = NULL
	,@acceptance_loop_id int = null
	,@product_name NVARCHAR(200)
	,@description NVARCHAR(500) = NULL
	,@is_deferred_child BIT = NULL
	,@is_cart_version BIT = NULL
	,@voucher_issuer_id INT = NULL
	,@product_category TINYINT = NULL
	,@product_tag TINYINT = NULL
	,@product_issuer TINYINT
	,@pin_code_type TINYINT = NULL
	,@pin_code_length TINYINT = NULL
	,@operation_note NVARCHAR(2000) = NULL
	,@sales_note NVARCHAR(2000) = NULL
	,@customer_service_note NVARCHAR(2000) = NULL
	,@can_extend BIT
	,@extension_scheme_id INT = NULL
	,@max_extend_times INT = NULL
	,@extension_end_date DATETIME = NULL
	,@same_as_contract_end_date BIT = NULL
	,@last_updated_by NVARCHAR(250)
	,@last_updated_on DATETIME
	,@issue_merchant INT = NULL
	,@multiple_selection_type tinyint = NULL
	,@error_message VARCHAR(100) = NULL OUTPUT
AS
BEGIN
	DECLARE @NewProductVersionId INT
		,@currentProductVerisionId INT
		,@currentVersion INT;

	SET @NewProductVersionId = 0;
	SET @error_message = '';

	BEGIN TRY
		BEGIN TRANSACTION;

		SELECT @currentProductVerisionId = pv.product_version_id
			,@currentVersion = pv.version
		FROM product.tb_p_product_version pv WITH (NOLOCK)
		WHERE product_id = @product_id
			AND pv.is_current_version = 1;

		UPDATE pv
		SET pv.is_current_version = 0
		FROM product.tb_p_product_version pv
		WHERE pv.product_version_id = @currentProductVerisionId;

		INSERT INTO product.tb_p_product_version (
			product_id
			,external_product_code
			,brand_id
			,sku_id
			,product_name
			,description
			,is_deferred_child
			,is_cart_version
			,reminder_id
			,product_category
			,product_tag
			,product_issuer
			,pin_code_type
			,pin_code_length
			,operation_note
			,sales_note
			,customer_service_note
			,min_redeem_quantity
			,max_issuing_quantity
			,valid_from
			,valid_to
			,reverse_limit_id
			,pre_authorization_expiry_interval
			,pre_authorization_expiry_unit
			,use_time_control
			,use_time_control_interval
			,max_total_redeem_amount_control
			,max_total_redeem_amount_control_interval
			,max_single_redeem_amount
			,add_to_wallet
			,wallet_status
			,can_extend
			,extension_scheme_id
			,max_extend_times
			,extension_end_date
			,same_as_contract_end_date
			,acceptance_loop_id
			,template_id
			,price_id
			,expiry_scheme_id
			,expiry_date
			,redeem_date_blacklist_id
			,redeem_time_restriction_id
			,combo_id
			,external_property_id
			,version
			,is_current_version
			,created_by
			,created_on
			,last_updated_by
			,last_updated_on
			,voucher_issuer_id
			,issue_merchant
			,wallet_description
			,wallet_image
			,is_fixed_expiry_policy
			)
		SELECT product_id
			,@external_product_code
			,@brand_id
			,@sku_id
			,@product_name
			,@description
			,@is_deferred_child
			,@is_cart_version
			,reminder_id
			,@product_category
			,@product_tag
			,@product_issuer
			,@pin_code_type
			,@pin_code_length
			,@operation_note
			,@sales_note
			,@customer_service_note
			,min_redeem_quantity
			,max_issuing_quantity
			,valid_from
			,valid_to
			,reverse_limit_id
			,pre_authorization_expiry_interval
			,pre_authorization_expiry_unit
			,use_time_control
			,use_time_control_interval
			,max_total_redeem_amount_control
			,max_total_redeem_amount_control_interval
			,max_single_redeem_amount
			,add_to_wallet
			,wallet_status
			,@can_extend
			,@extension_scheme_id
			,@max_extend_times
			,@extension_end_date
			,@same_as_contract_end_date
			,@acceptance_loop_id
			,template_id
			,price_id
			,expiry_scheme_id
			,expiry_date
			,redeem_date_blacklist_id
			,redeem_time_restriction_id
			,combo_id
			,external_property_id
			,@currentVersion + 1
			,1
			,created_by
			,created_on
			,@last_updated_by
			,@last_updated_on
			,voucher_issuer_id
			,@issue_merchant
			,wallet_description
			,wallet_image
			,is_fixed_expiry_policy
		FROM product.tb_p_product
		WHERE product_id = @product_id;

		SET @NewProductVersionId = SCOPE_IDENTITY();

		UPDATE p
		SET p.external_product_code = @external_product_code
			,p.brand_id = @brand_id
			,p.product_name = @product_name
			,p.description = @description
			,p.sku_id = @sku_id
			,p.is_deferred_child = @is_deferred_child
			,p.is_cart_version = @is_cart_version
			,p.voucher_issuer_id = @voucher_issuer_id
			,p.product_category = @product_category
			,p.product_tag = @product_tag
			,p.product_issuer = @product_issuer
			,p.pin_code_type = @pin_code_type
			,p.pin_code_length = @pin_code_length
			,p.operation_note = @operation_note
			,p.sales_note = @sales_note
			,p.customer_service_note = @customer_service_note
			,p.can_extend = @can_extend
			,p.extension_scheme_id = @extension_scheme_id
			,p.max_extend_times = @max_extend_times
			,p.extension_end_date = @extension_end_date
			,p.same_as_contract_end_date = @same_as_contract_end_date
			,p.last_updated_by = @last_updated_by
			,p.last_updated_on = @last_updated_on
			,p.issue_merchant = @issue_merchant
			,p.multiple_selection_type = @multiple_selection_type
			,p.acceptance_loop_id = @acceptance_loop_id
		FROM product.tb_p_product p
		WHERE p.product_id = @product_id;

		COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION;
		END
	END CATCH

	SELECT @NewProductVersionId;
END