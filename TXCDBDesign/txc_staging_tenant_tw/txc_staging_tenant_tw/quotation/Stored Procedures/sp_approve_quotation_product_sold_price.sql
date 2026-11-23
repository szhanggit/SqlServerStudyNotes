CREATE PROCEDURE [quotation].[sp_approve_quotation_product_sold_price]
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,

	@QuotationProductSoldPriceId	INT,
	@QuotationProductId	INT,
    @ValidityFrom	DATETIME,
    @ValidityEnd	DATETIME,
	@ApprovedBy	NVARCHAR(50),
	@ApprovedOn	DATETIME
	 
AS
BEGIN
    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY
		
		BEGIN TRANSACTION;
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;

		WITH qpsp AS
				(
				SELECT TOP 1 *
				FROM [quotation].[tb_qpsp_quotation_product_sold_price]
				WHERE status = 2 AND quotation_product_id = @QuotationProductId
				ORDER BY validity_end desc
				)
		UPDATE qpsp
		SET validity_end = DATEADD(SS,-1,@ValidityFrom)

		UPDATE [quotation].[tb_qpsp_quotation_product_sold_price]
        SET validity_from = @ValidityFrom
		,validity_end = @ValidityEnd
		,status = 2
        ,approved_by = @ApprovedBy
		,approved_on = @ApprovedOn
        WHERE id = @QuotationProductSoldPriceId

		IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to approve quotation product sold price';
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

		THROW
    END CATCH;

END