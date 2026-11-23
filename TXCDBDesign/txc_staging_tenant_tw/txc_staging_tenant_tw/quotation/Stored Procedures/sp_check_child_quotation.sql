CREATE PROCEDURE [quotation].[sp_check_child_quotation]
	@QuotationId int output,
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,
	
	@master_quotation_id int 
AS
BEGIN
    
	SET XACT_ABORT ON;

	BEGIN TRY

	    BEGIN TRANSACTION;
		
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;
		SET @QuotationId = 0;

if EXISTS(select 1 from tb_qm_quotation_map qmap with(nolock)
	join tb_q_quotation qm with(nolock) on qm.id = qmap.master_quotation_id
	join tb_q_quotation qc with(nolock) on qc.id = qmap.child_quotation_id
	where qm.id = @master_quotation_id )
BEGIN
	select @QuotationId = qc.id from tb_qm_quotation_map qmap with(nolock)
	join tb_q_quotation qm with(nolock) on qm.id = qmap.master_quotation_id
	join tb_q_quotation qc with(nolock) on qc.id = qmap.child_quotation_id
	where qm.id = @master_quotation_id 
	SET @IsSuccess = 1;
END
ELSE
BEGIN
		DECLARE @created_id table (id int)
		DECLARE @quotation_number NVARCHAR(100)

		EXEC quotation.getSequenceNextValue @SequenceName = 'Seq_QuotationNumber',
		@IsFixReturnLength = 1, @ReturnLength = 4,
		@PaddingCharacter = '0',
		@ret = @quotation_number OUTPUT
		
	    INSERT INTO tb_q_quotation
		(
		client_id  
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
		,created_by_system   
		,email_header_logo_id  
		,email_footer_logo_id  
		,IN_business_model  
		,teasers_type_id  
		,teasers_type_note 
		,teasers_owner_id  
		,teasers_owner_note 
		,enable_wallet_link  
		,wallet_group_by  
		)
		OUTPUT INSERTED.id INTO @created_id
		select 
		client_id  
		,CONVERT(NVARCHAR(50), GETDATE(), 112)+@quotation_number 
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
		,getdate()
		,sub_business_model_id  
		,finance_expire_days  
		,1   
		,email_header_logo_id  
		,email_footer_logo_id  
		,IN_business_model  
		,teasers_type_id  
		,teasers_type_note 
		,teasers_owner_id  
		,teasers_owner_note 
		,enable_wallet_link  
		,wallet_group_by  
		from tb_q_quotation with(nolock) 
		where id = @master_quotation_id

		IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
				SELECT @QuotationId = id FROM @created_id

				INSERT INTO [quotation].[tb_qm_quotation_map]
				(
					master_quotation_id,
					child_quotation_id
				)
				VALUES(
					@master_quotation_id,
					@QuotationId
				);
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to check child quotation';
			END

		stop_process:
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
       IF @@TRANCOUNT > 0
       BEGIN
          ROLLBACK TRANSACTION
       END;

	   THROW;
	END CATCH

	SET NOCOUNT, XACT_ABORT OFF;

END