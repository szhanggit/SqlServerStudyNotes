CREATE PROCEDURE [quotation].[sp_upd_quotation_template]
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,

	@QuotationTemplateId int,
	@EmailTemplateId    int,
	@SCVTemplateId  	int,
	@SMSTemplateId		int,
	@UpdatedOn			DATETIME,
    @UpdatedBy 			nvarchar(50)
	 
AS
BEGIN
    SET NOCOUNT, XACT_ABORT OFF;
	
	SET @IsSuccess = 0;
	SET @ErrorMessage = null;

    BEGIN TRY
	
		BEGIN TRANSACTION;

		UPDATE [quotation].[tb_qt_quotation_template]
		SET [email_template_id] = @EmailTemplateId
			,[SCV_template] = @SCVTemplateId
			,[sms_template] = @SMSTemplateId
			,[updated_on] = @UpdatedOn
			,[updated_by] = @UpdatedBy
		WHERE [id] = @QuotationTemplateId

        IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to update quotation template';
				GOTO stop_process;
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

		THROW
    END CATCH;

END