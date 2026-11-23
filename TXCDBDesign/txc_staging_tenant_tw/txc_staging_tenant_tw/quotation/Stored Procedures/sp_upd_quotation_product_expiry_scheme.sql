CREATE PROCEDURE [quotation].[sp_upd_quotation_product_expiry_scheme]
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,

	@ExpirySchemeId     INT,
    @ExpirationDate     DATETIME = NULL,
    @UpdatedBy          NVARCHAR(50),
	@UpdatedOn			DATETIME,
    @QuotationProductId INT
	 
AS
BEGIN
    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY
		
		BEGIN TRANSACTION;
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;

		UPDATE [quotation].[tb_qp_quotation_product]
        SET expiry_scheme_id = @ExpirySchemeId
        ,expiration_date = @ExpirationDate
        ,updated_by = @UpdatedBy
        ,updated_on = @UpdatedOn
        WHERE id = @QuotationProductId

        IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to update the quotation product expiry scheme';
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