CREATE PROCEDURE [quotation].[sp_upd_quote_prod_combo_seq]
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,
	@TvpQuoteProdComboSeqUpd quotation.tvp_QuoteProdComboSeqUpd readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET XACT_ABORT ON;

	BEGIN TRY
		BEGIN TRANSACTION;

		SET @IsSuccess = 0;
		SET @ErrorMessage = null;

		DECLARE @SeqCount int = (SELECT COUNT(*) FROM @TvpQuoteProdComboSeqUpd)

		UPDATE quotation.tb_qpc_quotation_product_combo 
			SET sequence = _tvp.Sequence
		FROM quotation.tb_qpc_quotation_product_combo _combo
		INNER JOIN @TvpQuoteProdComboSeqUpd _tvp ON _tvp.ChildClientQuotationProductId = _combo.child_client_quotation_product_id

		IF @@ROWCOUNT <> @SeqCount
			BEGIN
				SET @ErrorMessage = 'failed to update sequence';
				GOTO stop_process
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
	END CATCH
    
	SET XACT_ABORT OFF;
END