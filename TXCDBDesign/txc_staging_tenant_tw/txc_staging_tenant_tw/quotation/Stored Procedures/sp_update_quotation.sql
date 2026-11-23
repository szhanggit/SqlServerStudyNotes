CREATE PROCEDURE [quotation].[sp_update_quotation]
	@QuotationId int output,
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,
	
	@id int
	,@client_id int 
,@valid_from datetime 
,@valid_to datetime 
,@project_code nvarchar(50) 
,@project_name nvarchar(200) 
,@quotation_type int 
,@business_model_id int 
,@sales nvarchar(50) 
,@contact_name nvarchar(50) 
,@contact_position nvarchar(50) 
,@contact_phone nvarchar(50) 
,@contact_email nvarchar(100) 
,@status int 
,@business_type_id int 
,@end_client_id int 
,@campaign_type1_id int 
,@campaign_type2_id int 
,@service_fee_type int 
,@ignore_issue_number_limit bit 
,@finance_email nvarchar(255) 
,@sub_business_model_id int 
,@finance_expire_days int 
,@email_header_logo_id int 
,@email_footer_logo_id int 
,@IN_business_model int 
,@teasers_type_id int 
,@teasers_type_note nvarchar(200) 
,@teasers_owner_id int 
,@teasers_owner_note nvarchar(200) 
,@enable_wallet_link bit 
,@wallet_group_by int 
AS
BEGIN
    
	SET XACT_ABORT ON;

	BEGIN TRY

	    BEGIN TRANSACTION;
		
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;
		SET @QuotationId = 0;

		DECLARE @created_id table (id int)
		
	    update tb_q_quotation
		set 
	client_id =@client_id  
	,valid_from  =@valid_from  
	,valid_to  =@valid_to  
	,project_code =@project_code 
	,project_name =@project_name 
	,quotation_type  =@quotation_type  
	,business_model_id  =@business_model_id  
	,sales =@sales 
	,contact_name =@contact_name 
	,contact_position =@contact_position 
	,contact_phone =@contact_phone 
	,contact_email =@contact_email 
	,[status] =@status
	,business_type_id  =@business_type_id  
	,end_client_id  =@end_client_id  
	,campaign_type1_id  =@campaign_type1_id  
	,campaign_type2_id  =@campaign_type2_id  
	,service_fee_type  =@service_fee_type  
	,ignore_issue_number_limit  =@ignore_issue_number_limit  
	,finance_email =@finance_email 
	,updated_on  =getdate()
	,sub_business_model_id  =@sub_business_model_id  
	,finance_expire_days  =@finance_expire_days  
	,email_header_logo_id  =@email_header_logo_id  
	,email_footer_logo_id  =@email_footer_logo_id  
	,IN_business_model  =@IN_business_model  
	,teasers_type_id  =@teasers_type_id  
	,teasers_type_note =@teasers_type_note 
	,teasers_owner_id  =@teasers_owner_id  
	,teasers_owner_note =@teasers_owner_note 
	,enable_wallet_link  =@enable_wallet_link  
	,wallet_group_by  =@wallet_group_by  
	where id = @id

		IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
				SELECT @QuotationId = id FROM @created_id
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to update quotation';
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