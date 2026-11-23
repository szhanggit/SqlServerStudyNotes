CREATE PROCEDURE [quotation].[sp_del_quotation_product_sold_price]
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,

	@QuotationProductSoldPriceId	INT
	 
AS
BEGIN
    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY
		
		BEGIN TRANSACTION;
		
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;

		DELETE FROM [quotation].[tb_qpsp_quotation_product_sold_price]
        WHERE id = @QuotationProductSoldPriceId

        IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to delete quotation product sold price';
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