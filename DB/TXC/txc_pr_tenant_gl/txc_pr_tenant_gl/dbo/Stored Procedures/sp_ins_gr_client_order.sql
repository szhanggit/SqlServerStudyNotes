CREATE PROCEDURE [dbo].[sp_ins_gr_client_order]
	@GRClientOrderId int output,
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,
	@file_id int,
	@quotation_id nvarchar(250),
	@client_order_number nvarchar(100),
	@status int 
AS
BEGIN
	SET XACT_ABORT ON;

	BEGIN TRY

	    BEGIN TRANSACTION;
		
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;
		SET @GRClientOrderId = 0;

		DECLARE @created_id table (id int)

	    INSERT INTO tb_gocd_gr_client_order
		(
		[file_id],
		[quotation_id],
		[client_order_number],
		[status],
		[created_time],
		[updated_time]
		)
	OUTPUT INSERTED.id INTO @created_id
	VALUES
		(
			@file_id,
			@quotation_id,
			@client_order_number,
			@status,
			GETUTCDATE(),
			GETUTCDATE()
		);

		IF @@ROWCOUNT > 0
			BEGIN
		SET @IsSuccess = 1;
		SELECT @GRClientOrderId = id
		FROM @created_id
	END
		ELSE
			BEGIN
		SET @ErrorMessage = 'failed to add gr client order';
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
END