CREATE PROCEDURE [dbo].[sp_ins_resource]
	 @ResourceCode 	nvarchar(50),
	 @ResourceName 	nvarchar(50),
	 @Description 	nvarchar(255) = NULL,
	 @IsEnabled		bit,
	 @ModuleId		int
	 
AS
BEGIN
    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY

		INSERT INTO [dbo].[tb_r_resource]
           ([resource_code]
           ,[resource_name]
           ,[description]
           ,[is_enabled]
           ,[module_id])
		 VALUES
			   (@ResourceCode
			   ,@ResourceName
			   ,@Description
			   ,@IsEnabled
			   ,@ModuleId)
				 			 
    END TRY
    BEGIN CATCH 

       IF @@TRANCOUNT > 0
       BEGIN
          ROLLBACK TRANSACTION
       END;

		THROW
    END CATCH;

END