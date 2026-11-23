CREATE PROCEDURE quotation.sp_ins_quotation_product
	@QuotationProductId int output,
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,

	@QuotationId int,
	@ProductVersionId int,
	@ExpirySchemeId int,
	@MaxIssueVoucher int,
	@SystemProcessFee numeric(15,4),
	@ExpirationDate datetime,
	@EnabledCustomization bit,
	@Status int,
	@CreatedBy nvarchar(50),
	@CreatedOn datetime,
	@ApprovedBy nvarchar(50),
	@ApprovedOn datetime,
	@ChildStatus int,

	@SoldPrice numeric(15,4),
	@SoldPriceWithTax numeric(15,2),
	@SoldPricePercentage numeric(10,6),
	@FaceValueRangeFrom int,
	@FaceValueRangeTo int,
	@ValidityFrom datetime,
	@ValidityTo datetime,
	@SoldPriceStatus int,
  @ProductCode nvarchar(100),

	@ClientChildQuotationProductId int,

	@TvpQuoteProductChildComboAdd quotation.tvp_QuoteProductChildComboAdd readonly,
	@TvpQuoteProductSrvFeeTriggerTimeAdd quotation.tvp_QuoteProductSrvFeeTriggerTimeAdd readonly

AS
BEGIN
	SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;
        
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;
		SET @QuotationProductId = 0;
		
		DECLARE @created_quotation_product table (created_id int)

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
			child_status,
			updated_by,
			updated_on,
      		product_code
		)
		OUTPUT INSERTED.id INTO @created_quotation_product
		VALUES
		(
			@QuotationId,
			@ProductVersionId,
			@ExpirySchemeId,
			@MaxIssueVoucher,
			@SystemProcessFee,
			@ExpirationDate,
		    @EnabledCustomization,
			@Status,
			@CreatedBy,
			@CreatedOn,
			@ApprovedBy,
			@ApprovedOn,
			@ChildStatus,
			null,
			null,
      		@ProductCode
		);

		IF NOT EXISTS (SELECT * FROM @created_quotation_product)
			BEGIN
				SET @ErrorMessage = 'failed to insert quotation product';
				GOTO stop_process;
			END

		SELECT @QuotationProductId = created_id FROM @created_quotation_product;

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
		VALUES
		(
			@QuotationProductId,
			@SoldPrice,
			@SoldPriceWithTax,
			@SoldPricePercentage,
			@FaceValueRangeFrom,
			@FaceValueRangeTo,
			@ValidityFrom,
			@ValidityTo,
			@SoldPriceStatus,
			@CreatedBy,
			@CreatedOn,
			@ApprovedBy,
			@ApprovedOn
		);

		IF @@ROWCOUNT = 0
			BEGIN
				SET @ErrorMessage = 'failed to insert the quotation product sold price';
				GOTO stop_process;
			END

		INSERT INTO quotation.tb_qpsph_quotation_product_sold_price_history
		(
			quotation_product_id,
			sold_price,
			sold_price_with_tax,
			new_sold_price,
			new_sold_price_with_tax,
			approved_by,
			approved_on
		)
		VALUES
		(
			@QuotationProductId,
			@SoldPrice,
			@SoldPricePercentage,
			0,
			0,
			@ApprovedBy,
			@ApprovedOn
		)

		IF @@ROWCOUNT = 0
		BEGIN
			SET @ErrorMessage = 'failed to insert the quotation product sold price history';
			GOTO stop_process;
		END

		IF EXISTS (SELECT TOP 1 * FROM @TvpQuoteProductSrvFeeTriggerTimeAdd)
			BEGIN
				INSERT INTO quotation.tb_qpsftt_quotation_product_service_fee_trigger_time
				(
					quotation_product_id,
					service_fee_trigger_time_id,
					sold_price,
					sold_price_with_tax,
					validity_from,
					validity_end,
					status,
					created_by,
					created_on,
					approved_by,
					approved_on
				)
				SELECT 
					@QuotationProductId,
					ServiceFeeTriggerTimeId,
					SoldPrice,
					SoldPriceWithTax,
					ValidityFrom,
					ValidityEnd,
					Status,
					CreatedBy,
					CreatedOn,
					ApprovedBy,
					ApprovedOn
				FROM @TvpQuoteProductSrvFeeTriggerTimeAdd;

				IF @@ROWCOUNT = 0
					BEGIN
						SET @ErrorMessage = 'failed to insert product service trigger time';
						GOTO stop_process;
					END

			END

        --start process adding of child product

        IF EXISTS (SELECT TOP 1 * FROM @TvpQuoteProductChildComboAdd)			
			BEGIN
			    DECLARE @created_child_quotation_product table (created_id int, product_version_id int)
				
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
				OUTPUT inserted.id,inserted.product_version_id INTO @created_child_quotation_product
				SELECT
					@ClientChildQuotationProductId,
					ProductVersionId,
					ExpirySchemeId,
					MaxIssueVoucher,
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
				FROM @TvpQuoteProductChildComboAdd

				IF @@ROWCOUNT = 0
					BEGIN
						SET @ErrorMessage = 'failed to insert the child product';
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
				    created_id,
					SoldPrice,
					SoldPriceWithTax,
					SoldPricePercentage,
					FaceValueRangeFrom,
					FaceValueRangeTo,
					ValidityFrom,
					ValidityEnd,
					SoldPriceStatus,
					@CreatedBy,
					@CreatedOn,
					@ApprovedBy,
					@ApprovedOn
				FROM @created_child_quotation_product _created_child
				INNER JOIN @TvpQuoteProductChildComboAdd _combo ON _created_child.product_version_id = _combo.ProductVersionId; 
				
				IF @@ROWCOUNT = 0
					BEGIN
						SET @ErrorMessage = 'failed to insert the child quotation product sold price';
						GOTO stop_process;
					END

				INSERT INTO quotation.tb_qpsph_quotation_product_sold_price_history
				(
					quotation_product_id,
					sold_price,
					sold_price_with_tax,
					new_sold_price,
					new_sold_price_with_tax,
					approved_by,
					approved_on
				)
				SELECT
				    created_id,
					SoldPrice,
					SoldPriceWithTax,
					0,
		            0,
					@ApprovedBy,
					@ApprovedOn
				FROM @created_child_quotation_product _created_child
				INNER JOIN @TvpQuoteProductChildComboAdd _combo ON _created_child.product_version_id = _combo.ProductVersionId; 


				IF @@ROWCOUNT = 0
				BEGIN
					SET @ErrorMessage = 'failed to insert the quotation product sold price history';
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
					@QuotationProductId,
					created_id,
					ProductComboSetId,
					BusinessModelId,
					ComboExpirySchemeId,
					ComboExpirationDate,
					Sequence,
					CustomizationProductId,
					null,
					null
				FROM @created_child_quotation_product _created_child
				INNER JOIN @TvpQuoteProductChildComboAdd _product_combo ON _created_child.product_version_id = _product_combo.ProductVersionId

				IF @@ROWCOUNT = 0
					BEGIN
						SET @ErrorMessage = 'failed to insert the child product';
						GOTO stop_process;
					END
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