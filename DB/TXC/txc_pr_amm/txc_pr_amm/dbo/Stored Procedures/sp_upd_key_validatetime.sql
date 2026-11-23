CREATE PROCEDURE [dbo].[sp_upd_key_validatetime] 
	@keyName [nvarchar](8)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		SET NOCOUNT, XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;
        
			UPDATE dbo.tb_def_auth_key
			SET last_validate_time = GETUTCDATE()
			WHERE key_name = @keyName

        COMMIT TRANSACTION;

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