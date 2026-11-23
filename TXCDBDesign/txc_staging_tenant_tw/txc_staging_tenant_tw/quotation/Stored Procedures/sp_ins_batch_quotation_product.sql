CREATE PROCEDURE [quotation].[sp_ins_batch_quotation_product] 

	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,
	@QuotationId int,
	@CreatedBy nvarchar(50),
	@CreatedOn datetime,
	@ApprovedBy nvarchar(50),
	@ApprovedOn datetime,
	@TvpBatchQuoteProductAdd quotation.tvp_BatchQuoteProductAdd readonly,
	@TvpBatchQuoteProductSoldPriceAdd quotation.tvp_BatchQuoteProductSoldPriceAdd readonly,
	@TvpBatchQuoteProductComboAdd quotation.tvp_BatchQuoteProductComboAdd readonly
AS
BEGIN
	
	SET XACT_ABORT ON;
    
	BEGIN TRY

	BEGIN TRANSACTION;

	SET @IsSuccess = 0;
	SET @ErrorMessage = null;

	DECLARE @created_product_quote table (created_id int, product_version_id int)

	INSERT INTO quotation.tb_qp_quotation_product
	(
		quotation_id,
		product_version_id,
		expiry_scheme_id,
		max_issue_voucher_number,
		system_process_fee,
		expiration_date,
		enable_customization,
		status,
		created_by,
		created_on,
		approved_by,
		approved_on,
		updated_by,
		updated_on
	)
	OUTPUT inserted.id,inserted.product_version_id INTO @created_product_quote
	SELECT
		@QuotationId,
		ProductVersionId,
		ExpirySchemeId,
		MaxIssueVoucherNumber,
		SystemProcessFee,
		ExpirationDate,
		EnableCustomization,
		Status,
		@CreatedBy,
		@CreatedOn,
		@ApprovedBy,
		@ApprovedOn,
		NULL,
		NULL
	FROM @TvpBatchQuoteProductAdd

	IF @@ROWCOUNT = 0
		BEGIN
			SET @ErrorMessage = 'failed to insert quotation product';
		    GOTO stop_process;
		END

    INSERT INTO quotation.tb_qpsp_quotation_product_sold_price
	(
		quotation_product_id,
		sold_price,
		sold_price_with_tax,
		sold_price_percentage,
		face_value_range_from,
		face_value_range_to,
		validity_from,
		validity_end,
		status,
		created_by,
		created_on,
		approved_by,
		approved_on
	)
	SELECT
		_quote_product.created_id,
		SoldPrice,
		SoldPriceWithTax,
		SoldPricePercentage,
		FaceValueRangeFrom,
		FaceValueRangeTo,
		ValidityFrom,
		ValidityEnd,
		Status,
		@CreatedBy,
		@CreatedOn,
		@ApprovedBy,
		@ApprovedOn
	FROM @created_product_quote _quote_product
	INNER JOIN @TvpBatchQuoteProductSoldPriceAdd _sold_price ON _quote_product.product_version_id = _sold_price.ProductVersionId

	IF @@ROWCOUNT = 0
	BEGIN
		SET @ErrorMessage = 'failed to insert quotation product sold price';
		GOTO stop_process;
	END

	INSERT INTO quotation.tb_qpc_quotation_product_combo
	(
		quotation_product_id,
		child_client_quotation_product_id,
		product_combos_set_id,
		business_model_id,
		expiry_scheme_id,
		expiration_date,
		sequence,
		customization_product_id,
		updated_by,
		updated_on
	)
	SELECT
		_quote_product.created_id,
		ChildClientQuotationProductId,
		ProductComboSetId,
		BusinessModelId,
		ExpirySchemeId,
		ExpirationDate,
		Sequence,
		CustomizationProductId,
		NULL,
		NULL
	FROM @created_product_quote _quote_product
	INNER JOIN @TvpBatchQuoteProductComboAdd _product_combo ON _quote_product.product_version_id = _product_combo.ProductVersionId

	IF @@ROWCOUNT = 0
	BEGIN
		SET @ErrorMessage = 'failed to insert quotation product combo';
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
	
	SET NOCOUNT, XACT_ABORT OFF;


END