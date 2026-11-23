CREATE PROCEDURE [product].[sp_upd_condition]
         @product_id int
         ,@UserName nvarchar(250) 
		 ,@min_redeem_quantity int
		 ,@max_issuing_quantity int
		 ,@valid_from datetime
		 ,@valid_to datetime
		 ,@reverse_limit_id int
		 ,@pre_authorization_expiry_interval int
		 ,@pre_authorization_expiry_unit INT
         ,@reminder_id INT
         ,@use_time_control INT
         ,@use_time_control_interval INT
         ,@max_total_redeem_amount_control INT
         ,@max_total_redeem_amount_control_interval INT
         ,@max_single_redeem_amount int
		 ,@Result int output
AS
BEGIN
	SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;       
		declare @version int = 0;
        DECLARE @now DateTime = getutcdate();

		select @version = [version] from [product].[tb_p_product_version] with(nolock) where product_id = @product_id AND is_current_version = 1
		update [product].[tb_p_product_version]
		set is_current_version = 0
		where product_id = @product_id AND is_current_version = 1
		
		Update [product].[tb_p_product]
		set min_redeem_quantity = @min_redeem_quantity
		 ,max_issuing_quantity = @max_issuing_quantity 
		 ,valid_from = @valid_from
		 ,valid_to = @valid_to
		 ,reverse_limit_id = @reverse_limit_id
		 ,pre_authorization_expiry_interval = @pre_authorization_expiry_interval
		 ,pre_authorization_expiry_unit = @pre_authorization_expiry_unit
		 ,last_updated_on = @now
		 ,last_updated_by = @UserName
		 ,reminder_id = @reminder_id
		 ,use_time_control = @use_time_control
		 ,use_time_control_interval = @use_time_control_interval
		 ,max_total_redeem_amount_control = @max_total_redeem_amount_control
		 ,max_total_redeem_amount_control_interval = @max_total_redeem_amount_control_interval
		 ,max_single_redeem_amount = @max_single_redeem_amount
		where product_id = @product_id

		insert into [product].[tb_p_product_version] (
		product_id
		,external_product_code
		,brand_id
		,sku_id
		,product_name
		,[description]
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
		,[expiry_date]
		,redeem_date_blacklist_id
		,redeem_time_restriction_id
		,combo_id
		,external_property_id
		,[version]
		,is_current_version
		,created_by
		,created_on
		,last_updated_by
		,last_updated_on
		,[voucher_issuer_id]
		,[issue_merchant]
		,[wallet_description]
		,[wallet_image]
		,is_fixed_expiry_policy)
		select 
		product_id
		,external_product_code
		,brand_id
		,sku_id
		,product_name
		,[description]
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
		,[expiry_date]
		,redeem_date_blacklist_id
		,redeem_time_restriction_id
		,combo_id
		,external_property_id
		,(@version + 1) as [version]
		,1 as [is_current_version]
		,created_by
		,created_on
		,@UserName as [last_updated_by]
		,@now as [last_updated_on]
		,[voucher_issuer_id]
		,[issue_merchant]
		,[wallet_description]
		,[wallet_image]
		,is_fixed_expiry_policy
		from [product].[tb_p_product] with(nolock)
		where product_id = @product_id								
		
		set @Result = 1;
		
        COMMIT TRANSACTION;
	
		SELECT @@ROWCOUNT;
    END TRY
    BEGIN CATCH 
	   set @Result = -1;
       IF @@TRANCOUNT  > 0
       BEGIN
          ROLLBACK TRANSACTION		  
       END;

	   THROW;
    END CATCH;

    SET NOCOUNT, XACT_ABORT OFF;
END