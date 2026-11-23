CREATE PROCEDURE [dbo].[sp_ins_amm_tenant] 
	-- Add the parameters for the stored procedure here
	@TenantId int,
	@TenantCode nvarchar(50),
	@TenantName nvarchar(100),
	@IsSuccess BIT OUTPUT,
	@ErrorMsg NVARCHAR(250) OUTPUT
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;
			
		SET @IsSuccess = 0;
		SET @ErrorMsg = NULL;

		INSERT INTO dbo.tb_t_tenant
		(
			tenant_id,
			tenant_code,
			tenant_name,
			is_enabled
		)
		VALUES
		(
			@TenantId,
			@TenantCode,
			@TenantName,
			1
		)
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