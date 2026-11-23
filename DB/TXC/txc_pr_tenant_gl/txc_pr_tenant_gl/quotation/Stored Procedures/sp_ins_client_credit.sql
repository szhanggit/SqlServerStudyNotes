CREATE PROCEDURE [quotation].[sp_ins_client_credit]
	@IsSuccess bit output,
	@ErrorMessage nvarchar(250) output,
	
	@ClientId int,
	@CreditLimit decimal(18,2),
	@AvailableCredit decimal(18,2),
	@Parkfund decimal(18,2),
	@ClientEmail nvarchar(200),
	@ExtendEmail nvarchar(200)
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;

    BEGIN TRY
	
		BEGIN TRANSACTION;
		
		SET @IsSuccess = 0;
		SET @ErrorMessage = null;
		
		INSERT INTO [quotation].[tb_cc_client_credit]
		(
			client_id,
			credit_limit,
			available_credit,
			parkfund,
			client_email,
			extend_email,
			mail_send_status,
			modify_version
		)
		VALUES
		(
			@ClientId,
			@CreditLimit,
			@AvailableCredit,
			@Parkfund,
			@ClientEmail,
			@ExtendEmail,
			0,
			1
		)
		
		IF @@ROWCOUNT = 0
			BEGIN
				SET @ErrorMessage = 'failed to insert the client credit';
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