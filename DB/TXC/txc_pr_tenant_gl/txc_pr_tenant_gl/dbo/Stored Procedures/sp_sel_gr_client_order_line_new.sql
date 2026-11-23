CREATE PROCEDURE [dbo].sp_sel_gr_client_order_line_new
	@BatchSize INT,
	@FileId INT
AS
BEGIN

    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY

	BEGIN TRANSACTION;
	
    DECLARE @optimisticId nvarchar(64) = NEWID(); --use as a flag to lock the records
	
		UPDATE [dbo].[tb_gocd_gr_order_create_detail] 
			SET optimistic_lock = @optimisticId,
				[status] = 6
		WHERE id 
		IN (SELECT TOP (@BatchSize) gocd.id 
			FROM [dbo].[tb_gocd_gr_order_create_detail] gocd 
			INNER JOIN [dbo].[tb_gocd_gr_client_order] gco ON gocd.client_order_id = gco.id  
			WHERE gocd.[status] = 0 AND gco.[file_id] = @FileId
			)
	
		SELECT gocd.client_order_id "OrderNumber",		
		       gocd.product_code "ProductCode",
			   gocd.client_order_number "ClientOrderNumber",
			   gocd.quantity "Quantity",
			   GETUTCDATE() "ActiveDate",
			   gocd.beneficiary_name "FirstName",
			   gocd.email "Email",
			   gocd.mobile "ContactPhone",
			   gocd.id  "Id"
		FROM [dbo].[tb_gocd_gr_order_create_detail] gocd WITH(nolock)
		JOIN [dbo].[tb_gocd_gr_client_order] gco WITH(nolock) on gco.id = gocd.client_order_id
		WHERE gocd.[status]= 6 AND gocd.optimistic_lock = @optimisticId
		

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