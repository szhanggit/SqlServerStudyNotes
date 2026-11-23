CREATE PROCEDURE [quotation].[sp_ins_quote_prod_sold_price_percentage]
	@QuoteProdSoldPriceId int output,
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,
	
	@QuotationProductId int,
	@SoldPricePercentage numeric(10,6),
	@FaceValueRangeFrom int,
	@FaceValueRangeTo int,
	@ValidityFrom datetime,
	@ValidityEnd datetime,
	@Status int,
    @CreatedBy nvarchar(50),
    @CreatedOn datetime
AS
BEGIN
    
	SET XACT_ABORT ON;

	BEGIN TRY

	    BEGIN TRANSACTION;
		
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;
		SET @QuoteProdSoldPriceId = 0;

		DECLARE @created_id table (id int)
		
	    INSERT INTO tb_qpsp_quotation_product_sold_price
		(
			quotation_product_id,
			sold_price,
			sold_price_with_tax,
			validity_from,
			validity_end,
			status,
			created_by,
			created_on,
			sold_price_percentage,
			face_value_range_from,
			face_value_range_to
		)
		OUTPUT INSERTED.id INTO @created_id
		VALUES
		(
			@QuotationProductId,
			0,
			0,
			@ValidityFrom,
			@ValidityEnd,
			@Status,
			@CreatedBy,
			@CreatedOn,
			@SoldPricePercentage,
			@FaceValueRangeFrom,
			@FaceValueRangeTo
		);

		IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
				SELECT @QuoteProdSoldPriceId = id FROM @created_id
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to add quotation product sold price percentage';
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

	   THROW;
	END CATCH

	SET NOCOUNT, XACT_ABORT OFF;

END