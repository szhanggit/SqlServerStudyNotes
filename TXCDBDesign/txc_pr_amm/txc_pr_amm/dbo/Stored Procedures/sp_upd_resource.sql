CREATE PROCEDURE [dbo].[sp_upd_resource]
	 @ResourceId 	int,
	 @ResourceCode 	nvarchar(50),
	 @ResourceName 	nvarchar(50),
	 @Description 	nvarchar(255) = NULL,
	 @IsEnabled		bit,
	 @ModuleId		int
	 
AS
BEGIN
    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY

		UPDATE [dbo].[tb_r_resource]
		   SET [resource_code] = @ResourceCode
			  ,[resource_name] = @ResourceName
			  ,[description] = @Description
			  ,[is_enabled] = @IsEnabled
			  ,[module_id] = @ModuleId
		 WHERE [resource_id] = @ResourceId
				 			 
    END TRY
    BEGIN CATCH 

       IF @@TRANCOUNT > 0
       BEGIN
          ROLLBACK TRANSACTION
       END;

		THROW
    END CATCH;

END