CREATE PROCEDURE [quotation].[sp_ins_quotation_template]
	@QuotationTemplateId int output,
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,

	@QuotationId		int,
	@EmailTemplateId    int,
	@SCVTemplateId  	int,
	@SMSTemplateId		int,
	@CreatedOn			DATETIME,
    @CreatedBy 			nvarchar(50)
	 
AS
BEGIN
    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY
	
		BEGIN TRANSACTION;
	
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;
		SET @QuotationTemplateId = 0;

		DECLARE @created_id table (id int)

		INSERT INTO [quotation].[tb_qt_quotation_template]
           ([quotation_id]
           ,[email_template_id]
           ,[SCV_template]
           ,[sms_template]
           ,[created_on]
           ,[created_by])
		 OUTPUT INSERTED.id INTO @created_id
		 VALUES
			(@QuotationId
			,@EmailTemplateId
			,@SCVTemplateId
			,@SMSTemplateId
			,@CreatedOn
            ,@CreatedBy)

        IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
				SELECT @QuotationTemplateId = id FROM @created_id
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to add quotation template';
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