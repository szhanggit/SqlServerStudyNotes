CREATE PROCEDURE [dbo].[sp_upd_application]
	 @AppId	 		int,
	 @AppCode	 	nvarchar(50),
	 @AppKey	 	nvarchar(50),
	 @AppName	 	nvarchar(50),
	 @Description 	nvarchar(255) = NULL,
	 @IsEnabled		bit,
	 @IsMultiTenant		bit
	 
AS
BEGIN
    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY

		UPDATE [dbo].[tb_a_app]
		   SET [app_code] = @AppCode
			  ,[app_key] = @AppKey
			  ,[app_name] = @AppName
			  ,[description] = @Description
			  ,[is_enabled] = @IsEnabled
			  ,[is_multitenant] = @IsMultiTenant
		 WHERE [app_id] = @AppId
				 			 
    END TRY
    BEGIN CATCH 

       IF @@TRANCOUNT > 0
       BEGIN
          ROLLBACK TRANSACTION
       END;

		THROW
    END CATCH;

END