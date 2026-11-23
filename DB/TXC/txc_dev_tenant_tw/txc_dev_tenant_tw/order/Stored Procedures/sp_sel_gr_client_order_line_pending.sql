CREATE PROCEDURE [order].[sp_sel_gr_client_order_line_pending]
	@BatchSize INT
AS
BEGIN
    
    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY

	BEGIN TRANSACTION;

		DECLARE @optimisticId nvarchar(64) = NEWID(); --use as a flag to lock the records
		

		/* lock the pending record (status = 2 ) and set processing (status = 6)  */

		UPDATE [order].[tb_gocd_gr_order_create_detail]
			SET optimistic_lock = @optimisticId,
				[status] = 6
		WHERE id 
		IN (SELECT TOP (@BatchSize) id FROM [order].[tb_gocd_gr_order_create_detail] WHERE [status] = 2)
	
		/* select the locked recrod to send in voucher api */

		SELECT gocd.client_order_id "OrderNumber",		
		       gocd.product_code "ProductCode",
			   gocd.client_order_number "ClientOrderNumber",
			   gocd.quantity "Quantity",
			   GETUTCDATE() "ActiveDate",
			   gocd.beneficiary_name "FirstName",
			   gocd.email "Email",
			   gocd.mobile "ContactPhone",
			   gocd.id  "Id"
		FROM [order].[tb_gocd_gr_order_create_detail] gocd WITH(nolock)
		JOIN [order].[tb_gocd_gr_client_order] gco WITH(nolock) on gco.id = gocd.client_order_id
		JOIN [order].tb_eqom_emv_quotation_order_map eqom WITH(nolock) on gco.quotation_id = eqom.quotation_id
		WHERE gocd.[status] = 6 AND gocd.optimistic_lock = @optimisticId	

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