CREATE PROCEDURE [quotation].[sp_upd_client_credit]
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,
	
	@ClientId int,
	@CreditLimit decimal(18,2),
	@Parkfund decimal(18,2),
	@ClientEmail nvarchar(200),
	@ExtendEmail nvarchar(200),
	@ModifyVersion int
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;

    BEGIN TRY
	
		BEGIN TRANSACTION;
		
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;
		
		UPDATE [quotation].[tb_cc_client_credit]
		SET credit_limit = @CreditLimit,
			parkfund = @Parkfund,
			available_credit = available_credit + @CreditLimit + @Parkfund - credit_limit - parkfund,
			client_email = @ClientEmail,
			extend_email = @ExtendEmail,
			mail_send_status = 0,
			modify_version = modify_version + 1
		WHERE client_id = @ClientId
		AND	modify_version = @ModifyVersion
		
		IF @@ROWCOUNT = 0
			BEGIN
				SET @ErrorMessage = 'failed to update the client credit';
				GOTO stop_process;
			END
		
		SET @IsSuccess = 1;

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
    END CATCH;
	
	SET NOCOUNT, XACT_ABORT OFF;

END