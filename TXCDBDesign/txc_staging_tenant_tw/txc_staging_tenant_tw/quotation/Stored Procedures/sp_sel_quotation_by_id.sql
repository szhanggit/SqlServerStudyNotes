CREATE PROCEDURE [quotation].[sp_sel_quotation_by_id]
	@Id	int
AS
BEGIN

    SET NOCOUNT, XACT_ABORT ON;

    BEGIN TRY
		
		SELECT 
         id
        ,client_id  
        ,quotation_number 
        ,valid_from  
        ,valid_to  
        ,project_code 
        ,project_name 
        ,quotation_type  
        ,business_model_id  
        ,sales 
        ,contact_name 
        ,contact_position 
        ,contact_phone 
        ,contact_email 
        ,[status] 
        ,business_type_id  
        ,end_client_id  
        ,campaign_type1_id  
        ,campaign_type2_id  
        ,service_fee_type  
        ,ignore_issue_number_limit  
        ,finance_email 
        ,updated_on  
        ,sub_business_model_id  
        ,finance_expire_days  
        ,email_header_logo_id  
        ,email_footer_logo_id  
        ,IN_business_model  
        ,teasers_type_id  
        ,teasers_type_note 
        ,teasers_owner_id  
        ,teasers_owner_note 
        ,enable_wallet_link  
        ,wallet_group_by FROM [quotation].[tb_q_quotation] with(nolock) WHERE id = @Id
				 			 
    END TRY
    BEGIN CATCH 
		THROW
    END CATCH;
	
	SET NOCOUNT, XACT_ABORT OFF;

END