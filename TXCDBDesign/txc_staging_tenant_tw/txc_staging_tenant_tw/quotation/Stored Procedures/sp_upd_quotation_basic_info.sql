CREATE PROCEDURE [quotation].[sp_upd_quotation_basic_info]
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,

	@ValidityTo     DATETIME,
    @ContactName    NVARCHAR(50),
    @ContactEmail   NVARCHAR(100),
	@FinanceEmail   NVARCHAR(255),
	@UpdatedOn		DATETIME,
    @QuotationId 	INT
	 
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;

    BEGIN TRY
		
		BEGIN TRANSACTION;
			SET @IsSuccess = 0;
			SET @ErrorMessage = null;

			UPDATE [quotation].[tb_q_quotation]
			SET valid_to = @ValidityTo
			,contact_name = @ContactName
			,contact_email = @ContactEmail
			,finance_email = @FinanceEmail
			,updated_on = @UpdatedOn
			WHERE id = @QuotationId

			IF @@ROWCOUNT > 0
				BEGIN
					SET @IsSuccess = 1;
				END
			ELSE
				BEGIN
					SET @ErrorMessage = 'failed to update quotation basic info';
				END
		COMMIT TRANSACTION;
		
    END TRY
    BEGIN CATCH 

       IF @@TRANCOUNT > 0
       BEGIN
          ROLLBACK TRANSACTION;
       END;

		THROW
    END CATCH;
	
	SET NOCOUNT, XACT_ABORT OFF;

END