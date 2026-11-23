CREATE PROCEDURE [quotation].[sp_ins_quotation_billing]
	@QuotationBillingId int output,
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,

	@QuotationId       int,
	@AdvanceBilling    bit,
	@BillingFrequency  bit,
	@BillingDate		int,
	@PaymentTerm		int,
    @BBXAdvanceBilling bit,
    @AutoCreateBilling bit = NULL,
    @SalesEmail        nvarchar(255) = NULL,
    @IsCreatedFapaio   bit,
    @IsBBXAdvancedBilling  bit,
    @IsAutoCreateFapaio    bit,
    @BBXAdvancedBillingNumber  nvarchar(2000) = NULL,
    @AutoCreateFapaioNumber    nvarchar(2000) = NULL,
    @AdvancedBillingOffReason  nvarchar(1000) = NULL
	 
AS
BEGIN
    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY
	
		BEGIN TRANSACTION;
	
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;
		SET @QuotationBillingId = 0;

		DECLARE @created_id table (id int)

		INSERT INTO [quotation].[tb_qb_quotation_billing]
           ([quotation_id]
           ,[advance_billing]
           ,[billing_frequency]
           ,[billing_date]
           ,[payment_term]
           ,[bbx_advance_billing]
           ,[auto_create_billing]
           ,[sales_email]
           ,[is_created_fapaio]
           ,[is_bbx_advanced_billing]
           ,[is_auto_create_fapaio]
           ,[bbx_advancedB_billing_number]
           ,[auto_create_fapaio_number]
           ,[advanced_billing_off_reason])
		 OUTPUT INSERTED.id INTO @created_id
		 VALUES
			(@QuotationId
			,@AdvanceBilling
			,@BillingFrequency
			,@BillingDate
			,@PaymentTerm
            ,@BBXAdvanceBilling
            ,@AutoCreateBilling
            ,@SalesEmail
            ,@IsCreatedFapaio
            ,@IsBBXAdvancedBilling
            ,@IsAutoCreateFapaio
            ,@BBXAdvancedBillingNumber
            ,@AutoCreateFapaioNumber
            ,@AdvancedBillingOffReason)

        IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
				SELECT @QuotationBillingId = id FROM @created_id
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to add quotation billing';
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