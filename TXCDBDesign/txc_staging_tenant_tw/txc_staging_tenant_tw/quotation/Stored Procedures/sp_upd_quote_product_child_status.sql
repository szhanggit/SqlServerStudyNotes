CREATE PROCEDURE [quotation].[sp_upd_quote_product_child_status]
	-- Add the parameters for the stored procedure here
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,

	@QuotationProductId int,
	@ChildStatus int
AS
BEGIN
    SET XACT_ABORT ON;
	BEGIN TRY
		BEGIN TRANSACTION;

		SET @IsSuccess = 0;
		SET @ErrorMessage = null;
         
        UPDATE quotation.tb_qp_quotation_product
		SET child_status = @ChildStatus
		WHERE id = @QuotationProductId

		IF @@ROWCOUNT = 0
		BEGIN
			SET @ErrorMessage = 'failed to update child status';
			GOTO stop_process;
		END

        SET @IsSuccess = 1;

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
	END CATCH;
    SET XACT_ABORT OFF;
END