CREATE PROCEDURE [dbo].[sp_sel_order_for_order_split]

AS
BEGIN
    
	SET XACT_ABORT ON;

	BEGIN TRY

	    BEGIN TRANSACTION;

		DECLARE @optimisticId NVARCHAR(64) = NEWID(); --use as a flag to lock the records
		
		UPDATE [dbo].[tb_ob_order_basic] 
			SET optimistic_lock = @optimisticId, [executing_status] = 2 --assign voucher
		WHERE optimistic_lock IS NULL AND [status] = 32 --publishing
		AND executing_status = 1 --not start

		SELECT 
			o.id "OrderId"
		FROM [dbo].tb_ob_order_basic o
		WHERE o.[executing_status] = 2 --assign voucher
		AND optimistic_lock = @optimisticId

		COMMIT TRANSACTION;
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