CREATE PROCEDURE [dbo].[sp_sel_file_to_process]
AS
BEGIN

    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY

	BEGIN TRANSACTION;
	
		DECLARE @optimisticId nvarchar(64) = NEWID(); --use as a flag to lock the records
		DECLARE @batch_file_tbl table (id int);
		DECLARE @file_id int;

		UPDATE [dbo].tb_bf_batch_file 
			SET optimistic_lock = @optimisticId
		OUTPUT inserted.id INTO @batch_file_tbl (id)
		WHERE id IN (SELECT TOP 1 ID FROM [dbo].tb_bf_batch_file WHERE optimistic_lock IS NULL AND [status] = 1 ORDER BY saved_date)
	
		SELECT TOP 1 @file_id = id FROM @batch_file_tbl
	
		SELECT
			[file_id] "FileId",
			@optimisticId "OptimisticLock",
			COUNT(*) "TotalOrderLine"
 		FROM [dbo].tb_eco_emv_client_order eco WITH(nolock)
		JOIN [dbo].tb_ecol_emv_client_order_line ecol WITH(nolock)
		  ON eco.id = ecol.emv_client_order_id
		WHERE eco.[file_id] = @file_id
		GROUP BY eco.[file_id],eco.id

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