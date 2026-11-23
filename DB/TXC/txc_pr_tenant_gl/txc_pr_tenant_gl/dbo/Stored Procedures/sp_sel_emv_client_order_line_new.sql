CREATE PROCEDURE [dbo].[sp_sel_emv_client_order_line_new]
	@BatchSize INT,
	@FileId INT
AS
BEGIN

    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY

	BEGIN TRANSACTION;
	
    DECLARE @optimisticId nvarchar(64) = NEWID(); --use as a flag to lock the records
	
		UPDATE [dbo].tb_ecol_emv_client_order_line 
			SET optimistic_lock = @optimisticId,
				[status] = 6
		WHERE id 
		IN (SELECT TOP (@BatchSize) ecol.id 
			FROM [dbo].tb_ecol_emv_client_order_line ecol 
			INNER JOIN [dbo].[tb_eco_emv_client_order] eco ON ecol.emv_client_order_id = eco.id  
			WHERE ecol.[status] = 0 AND eco.[file_id] = @FileId
			ORDER BY ecol.created_time ,ecol.[priority] ASC)
	
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
		FROM [dbo].tb_ecol_emv_client_order_line ecol WITH(nolock)
		JOIN [dbo].tb_eco_emv_client_order eco WITH(nolock) on eco.id = ecol.emv_client_order_id
		WHERE ecol.[status]= 6 AND ecol.optimistic_lock = @optimisticId
		ORDER BY ecol.[priority] ASC

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