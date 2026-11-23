CREATE PROCEDURE [dbo].[sp_ins_order_activate_mode]
	@OrderActivateModeId int output,
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,

	@order_id int ,
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
		SET @OrderActivateModeId = 0;

		DECLARE @created_id table (id int)

	    INSERT INTO tb_oam_order_activate_mode
		(
		order_id  ,
		mode  ,
		after_published  ,
		fix_date  
		)
	OUTPUT INSERTED.id INTO @created_id
	VALUES
		(
			@order_id,
			@mode  ,
			@after_published  ,
			@fix_date
		);

		IF @@ROWCOUNT > 0
			BEGIN
		SET @IsSuccess = 1;
		SELECT @OrderActivateModeId = id
		FROM @created_id
	END
		ELSE
			BEGIN
		SET @ErrorMessage = 'failed to add order activate mode';
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