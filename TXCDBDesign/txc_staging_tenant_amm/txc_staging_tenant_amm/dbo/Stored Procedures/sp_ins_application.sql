CREATE PROCEDURE [dbo].[sp_ins_application]
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

		INSERT INTO [dbo].[tb_a_app]
           ([app_code]
           ,[app_key]
           ,[app_name]
           ,[description]
           ,[is_enabled]
           ,[is_multitenant])
		 VALUES
			   (@AppCode
			   ,@AppKey
			   ,@AppName
			   ,@Description
			   ,@IsEnabled
			   ,@IsMultiTenant)
				 			 
    END TRY
    BEGIN CATCH 

       IF @@TRANCOUNT > 0
       BEGIN
          ROLLBACK TRANSACTION
       END;

		THROW
    END CATCH;

END