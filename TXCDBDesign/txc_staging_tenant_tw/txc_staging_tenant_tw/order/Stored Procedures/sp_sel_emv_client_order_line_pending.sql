CREATE PROCEDURE [order].[sp_sel_emv_client_order_line_pending]
	@BatchSize INT
AS
BEGIN
    
    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY

	BEGIN TRANSACTION;

		DECLARE @optimisticId nvarchar(64) = NEWID(); --use as a flag to lock the records
		

		/* lock the pending record (status = 2 ) and set processing (status = 6)  */

		UPDATE [order].tb_ecol_emv_client_order_line 
			SET optimistic_lock = @optimisticId,
				[status] = 6
		WHERE id 
		IN (SELECT TOP (@BatchSize) id FROM [order].tb_ecol_emv_client_order_line WHERE [status] = 2 ORDER BY created_time ,[priority] ASC)
	
		/* select the locked recrod to send in voucher api */

		SELECT ecol.order_number "OrderNumber",
			   ecol.sku "ProductCode",
			   ecol.client_order_number "ClientOrderNumber",
			   ecol.quantity "Quantity",
			   ecol.[priority] "Priority",
			   GETUTCDATE() "ActiveDate",
			   ecol.first_name "FirstName",
			   ecol.email "Email",
			   ecol.contact_phone "ContactPhone",
			   ecol.delivery_type "DeliveryType",
			   ecol.rcn "Rcn",
			   ecol.id  "Id"
		FROM [order].tb_ecol_emv_client_order_line ecol WITH(nolock)
		JOIN [order].tb_eco_emv_client_order eco WITH(nolock) on eco.id = ecol.emv_client_order_id
		JOIN [order].tb_eqom_emv_quotation_order_map eqom WITH(nolock) on eco.quotation_id = eqom.quotation_id		
		WHERE ecol.[status] = 6 AND ecol.optimistic_lock = @optimisticId	

	COMMIT TRANSACTION;
				 			 
    END TRY
    BEGIN CATCH 
       IF @@TRANCOUNT > 0
       BEGIN
          ROLLBACK TRANSACTION
       END;

		THROW
    END CATCH;
	SET NOCOUNT, XACT_ABORT OFF;
	
END