CREATE PROCEDURE [dbo].[sp_upd_status_gr_client_order_line]
	@Id int,
	@Status int,
	@IsSuccess bit output
AS
BEGIN

    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY

	BEGIN TRANSACTION;
	
		SET @IsSuccess = 0;

		UPDATE [dbo].[tb_gocd_gr_order_create_detail]
			SET [status] = @status, optimistic_lock = null
		WHERE id = @id

		IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
			END
	
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