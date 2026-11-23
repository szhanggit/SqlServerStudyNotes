CREATE PROCEDURE [quotation].[sp_approve_quotation_product]
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,
	
	@QuotationProductId	int,
	@ApprovedBy	nvarchar(50)

AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON;
	
	SET @IsSuccess = 0;
	SET @ErrorMessage = null;
		
	DECLARE @CurrentDate  DATETIME;
	SET @CurrentDate = FORMAT(GETDATE(),'yyyy-MM-dd');

    BEGIN TRY

        BEGIN TRANSACTION
		
		-- Change quotation product status
		UPDATE [quotation].[tb_qp_quotation_product]
		SET [status] = 32
		,[approved_by] = @ApprovedBy
		,[approved_on] = GETDATE()
		WHERE [id] = @QuotationProductId
		AND [status] != 32
		
		IF @@ROWCOUNT = 0
			BEGIN
				SET @ErrorMessage = 'failed to change quotation product status';
				GOTO stop_process;
			END
		
		-- Add quotation product sold price history
		INSERT INTO quotation.tb_qpsph_quotation_product_sold_price_history
			([quotation_product_id]
			,[sold_price]
			,[sold_price_with_tax]
			,[new_sold_price]
			,[new_sold_price_with_tax]
			,[approved_on]
			,[approved_by])
		SELECT
			qp.id
			,0
			,0
			,ISNULL(qpsp.sold_price, 0) -- when null, means dynamic face value
			,qpsp.sold_price_with_tax
			,GETDATE()
			,@ApprovedBy
		FROM [quotation].[tb_qpsp_quotation_product_sold_price] as qpsp
		INNER JOIN [quotation].[tb_qp_quotation_product] as qp ON qpsp.[quotation_product_id] = qp.[id]
		WHERE qp.[id] = @QuotationProductId
		AND qpsp.[status] = 1
		
		-- Sold price -> If current is later than validity from,then set validity fome to now.
		UPDATE qpsp
		SET qpsp.[validity_from] = @CurrentDate
		FROM [quotation].[tb_qpsp_quotation_product_sold_price] as qpsp
		INNER JOIN [quotation].[tb_qp_quotation_product] as qp ON qpsp.[quotation_product_id] = qp.[id]
		WHERE qp.id = @QuotationProductId
		AND qpsp.[Status] = 1	
		AND qpsp.[validity_from] < @CurrentDate
		
		-- Sold price -> set previous validity end to the day before today
		UPDATE qpsp
		SET qpsp.[validity_end] = DATEADD(SS,-1,qpsp2.[validity_from])
		FROM [quotation].[tb_qpsp_quotation_product_sold_price] as qpsp
		INNER JOIN [quotation].[tb_qp_quotation_product] as qp ON qpsp.[quotation_product_id] = qp.[id]
		INNER JOIN [quotation].[tb_qpsp_quotation_product_sold_price] as qpsp2 on qpsp2.[quotation_product_id] = qpsp.[quotation_product_id]
		WHERE qp.[id] = @QuotationProductId
		AND qpsp.[status] = 2
		AND qpsp.[validity_end] = '3999-01-01 00:00:00.000'
		AND qpsp2.[status] = 1
		
		-- Approve product sold price
		UPDATE qpsp
		SET qpsp.[status] = 2
			,[approved_by] = @ApprovedBy
			,[approved_on] = GETDATE()
		FROM [quotation].[tb_qpsp_quotation_product_sold_price] as qpsp
		INNER JOIN [quotation].[tb_qp_quotation_product] as qp ON qpsp.[quotation_product_id] = qp.[id]
		WHERE qp.[id] = @QuotationProductId
		AND qpsp.[status] = 1
		
		-- Service fee trigger time -> If current is later than validity from,then set validity fome to now.
		UPDATE qpsftt
		SET qpsftt.[validity_from] = @CurrentDate
		FROM [quotation].[tb_qpsftt_quotation_product_service_fee_trigger_time] AS qpsftt
		INNER JOIN [quotation].[tb_qp_quotation_product] AS qp ON qpsftt.[quotation_product_id] = qp.[id]
		WHERE qp.[id] = @QuotationProductId
		AND qpsftt.[status] = 1 
		AND qpsftt.[validity_from] < @CurrentDate
		
		-- Service fee trigger time -> set previous validity end to the day before today
		UPDATE qpsftt
		SET qpsftt.[validity_end] = DATEADD(SS,-1,qpsftt2.[validity_from])
		FROM [quotation].[tb_qpsftt_quotation_product_service_fee_trigger_time] AS qpsftt
		INNER JOIN [quotation].[tb_qp_quotation_product] AS qp ON qpsftt.[quotation_product_id] = qp.[id]
		INNER JOIN [quotation].[tb_qpsftt_quotation_product_service_fee_trigger_time] AS qpsftt2 ON qpsftt.[quotation_product_id] = qpsftt2.[quotation_product_id] AND qpsftt.[service_fee_trigger_time_id] = qpsftt2.[service_fee_trigger_time_id]
		WHERE qp.id = @QuotationProductId
		AND qpsftt.[status] = 2
		AND qpsftt.[validity_end] = '3999-01-01 00:00:00.000'
		AND qpsftt2.[status] = 1
		
		-- Approve service fee sold price
		UPDATE qpsftt
		SET qpsftt.[status] = 2
			,[approved_by] = @ApprovedBy
			,[approved_on] = GETDATE()
		FROM [quotation].[tb_qpsftt_quotation_product_service_fee_trigger_time] AS qpsftt
		INNER JOIN [quotation].[tb_qp_quotation_product] AS qp ON qpsftt.[quotation_product_id] = qp.[id]
		WHERE qp.id = @QuotationProductId
		AND qpsftt.[status] = 1

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