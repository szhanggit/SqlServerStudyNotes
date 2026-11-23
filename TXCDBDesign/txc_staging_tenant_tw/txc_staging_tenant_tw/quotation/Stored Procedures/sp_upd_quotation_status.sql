CREATE PROCEDURE [quotation].[sp_upd_quotation_status]
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,

	@QuotationId 	int,
	@Status			int,
	@Username		nvarchar(50)
	 
AS
BEGIN
    SET NOCOUNT, XACT_ABORT OFF;
	
	SET @IsSuccess = 0;
	SET @ErrorMessage = null;

    BEGIN TRY
	
		BEGIN TRANSACTION;

		UPDATE [quotation].[tb_q_quotation]
		SET [status] = @Status
		WHERE [id] = @QuotationId

        IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to update quotation status';
				GOTO stop_process;
			END
			
		UPDATE qp
		SET qp.[status] = @Status
		FROM [quotation].[tb_qp_quotation_product] as qp
		INNER JOIN [quotation].[tb_q_quotation] as q on qp.quotation_id = q.id
		WHERE q.id = @QuotationId
		
		IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to update quotation product status';
				GOTO stop_process;
			END
		
		IF(@Status = 32)
			BEGIN
				-- Add quotation product sold price history
				INSERT INTO qpsp
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
					,@Username
				FROM [quotation].[tb_qpsp_quotation_product_sold_price] as qpsp
				INNER JOIN [quotation].[tb_qp_quotation_product] as qp ON qpsp.[quotation_product_id] = qp.[id]
				INNER JOIN [quotation].[tb_q_quotation] AS q ON qp.[quotation_id] = q.[id]
				WHERE q.[id] = @QuotationId
				AND qpsp.[status] = 1
				
				-- Approve product sold price
				UPDATE qpsp
				SET qpsp.[status] = 2
					,[approved_by] = @Username
					,[approved_on] = GETDATE()
				FROM [quotation].[tb_qpsp_quotation_product_sold_price] as qpsp
				INNER JOIN [quotation].[tb_qp_quotation_product] as qp ON qpsp.[quotation_product_id] = qp.[id]
				INNER JOIN [quotation].[tb_q_quotation] AS q ON qp.[quotation_id] = q.[id]
				WHERE q.id = @QuotationId
				AND qpsp.[status] = 1
				
				-- Approve service fee sold price
				UPDATE qpsftt
				SET qpsftt.[status] = 2
					,[approved_by] = @Username
					,[approved_on] = GETDATE()
				FROM [quotation].[tb_qpsftt_quotation_product_service_fee_trigger_time] AS qpsftt
				INNER JOIN [quotation].[tb_qp_quotation_product] AS qp ON qpsftt.[quotation_product_id] = qp.[id]
				INNER JOIN [quotation].[tb_q_quotation] AS q ON qp.[quotation_id] = q.[id]
				WHERE q.id = @QuotationId
				AND qpsftt.[status] = 1
				
			END
				
		-- Add quotation status history
		INSERT INTO [quotation].[tb_qsh_quotation_status_history]
					([quotation_id]
					,[operation]
					,[operator]
					,[operation_time])
				VALUES
					(@QuotationId
					 ,CONVERT(NVARCHAR(50),@Status)
					 ,@Username
					 ,GETDATE())
		
	
	
		IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to insert quotation status history';
				GOTO stop_process;
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

		THROW
    END CATCH;

END