CREATE PROCEDURE [product].[sp_upd_product_price] @ProductId AS INT
	,@SellingPricePrepaid AS DECIMAL(15, 4)
	,@SellingPricePrepaidWithTax AS DECIMAL(15, 4)
	,@SellingPricePostpaid AS DECIMAL(15, 4)
	,@SellingPricePostpaidWithTax AS DECIMAL(15, 4)
	,@CustomerFeePrepaid AS DECIMAL(15, 4)
	,@CustomerFeePrepaidWithTax AS DECIMAL(15, 4)
	,@CustomerFeePostpaid AS DECIMAL(15, 4)
	,@CustomerFeePostpaidWithTax AS DECIMAL(15, 4)
	,@SkuId INT = NULL
	,@UserName NVARCHAR(250)
	,@currentDateTime DATETIME
AS
BEGIN
	BEGIN TRY
		DECLARE @previousProductVersionId INT
			,@previousVersionNumber INT
			,@newPriceId INT;

		SELECT @previousProductVersionId = tppv.product_version_id
			,@previousVersionNumber = tppv.version
		FROM product.tb_p_product_version tppv WITH (NOLOCK)
		WHERE tppv.product_id = @ProductId
			AND tppv.is_current_version = 1;

		BEGIN TRANSACTION;

		INSERT INTO product.tb_p_product_price (
			selling_price_prepaid
			,selling_price_prepaid_with_tax
			,selling_price_postpaid
			,selling_price_postpaid_with_tax
			,customer_fee_prepaid
			,customer_fee_prepaid_with_tax
			,customer_fee_postpaid
			,customer_fee_postpaid_with_tax
			)
		VALUES (
			@SellingPricePrepaid
			,@SellingPricePrepaidWithTax
			,@SellingPricePostpaid
			,@SellingPricePostpaidWithTax
			,@CustomerFeePrepaid
			,@CustomerFeePrepaidWithTax
			,@CustomerFeePostpaid
			,@CustomerFeePostpaidWithTax
			);

		SET @newPriceId = SCOPE_IDENTITY();

		IF @SkuId > 0
		BEGIN
			UPDATE product.tb_p_product
			SET sku_id = @SkuId
			WHERE product_id = @ProductId;
		END

		UPDATE tpp
		SET tpp.price_id = @newPriceId
			,tpp.last_updated_by = @UserName
			,tpp.last_updated_on = @currentDateTime
		FROM product.tb_p_product tpp
		WHERE tpp.product_id = @ProductId;

		UPDATE tppv
		SET tppv.is_current_version = 0
		FROM product.tb_p_product_version tppv
		WHERE tppv.product_version_id = @previousProductVersionId;

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
			,@newPriceId
			,expiry_scheme_id
			,expiry_date
			,redeem_date_blacklist_id
			,redeem_time_restriction_id
			,combo_id
			,external_property_id
			,@previousVersionNumber + 1
			,1
			,created_by
			,created_on
			,@UserName
			,@currentDateTime
			,voucher_issuer_id
			,issue_merchant
			,wallet_description
			,wallet_image
			,is_fixed_expiry_policy
		FROM product.tb_p_product tpp WITH (NOLOCK)
		WHERE tpp.product_id = @ProductId;

		COMMIT TRANSACTION;

		SELECT SCOPE_IDENTITY();
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION;
		END;

		THROW;
	END CATCH
END