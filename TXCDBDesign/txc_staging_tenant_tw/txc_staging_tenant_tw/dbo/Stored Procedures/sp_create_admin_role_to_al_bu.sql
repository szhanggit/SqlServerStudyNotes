CREATE PROCEDURE [dbo].[sp_create_admin_role_to_al_bu]
	-- Add the parameters for the stored procedure here
	@TenantId INT,
	@IsSuccess BIT OUTPUT,
	@ErrorMsg NVARCHAR(250) OUTPUT
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;
			
		SET @IsSuccess = 0;
		SET @ErrorMsg = NULL;

		INSERT INTO dbo.tb_r_role
		(
			role_name,
			[description],
			tenant_id,
			app_id,
			is_enabled,
			is_admin
		)
		SELECT
			'Administrator',
			'Administrator Default',
			@TenantId,
			app_id,
			is_enabled,
			1
		FROM dbo.tb_a_app

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