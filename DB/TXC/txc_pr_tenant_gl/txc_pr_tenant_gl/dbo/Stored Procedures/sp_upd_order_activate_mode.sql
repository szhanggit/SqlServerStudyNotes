CREATE PROCEDURE [dbo].[sp_upd_order_activate_mode]
	@OrderActivateModeId int output,
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,

	@id int,
	@mode int ,
	@after_published int ,
	@fix_date datetime 
AS
BEGIN
    
	SET XACT_ABORT ON;

	BEGIN TRY

	    BEGIN TRANSACTION;
		
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;
		SET @OrderActivateModeId = @id;

	    update tb_oam_order_activate_mode set
				mode  =		@mode  ,
				after_published = @after_published,
				fix_date = @fix_date
		where id = @id

		IF @@ROWCOUNT > 0
			BEGIN
				SET @IsSuccess = 1;
			END
		ELSE
			BEGIN
				SET @ErrorMessage = 'failed to update order activate mode';
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

	   THROW;
	END CATCH

	SET NOCOUNT, XACT_ABORT OFF;

END