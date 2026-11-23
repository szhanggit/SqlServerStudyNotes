CREATE PROCEDURE [dbo].[sp_ins_role]
	 @RoleName 		nvarchar(100),
	 @Description 	nvarchar(255) = NULL,
	 @IsEnabled		bit,
	 @TenantId		int,
	 @AppId			int,
	 @IsAdminRole   bit,
	 @OperationId   tvp_ins_role_operation_id readonly,
	 @RoleId        int output,
	 @IsSuccess     bit output,
	 @ErrorMsg      nvarchar(150) output
	 
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;

    BEGIN TRY

		BEGIN TRANSACTION;
		
		SET @IsSuccess = 0;
		SET @ErrorMsg = NULL;
		SET @RoleId = 0;

		INSERT INTO [dbo].[tb_r_role]
           ([role_name]
           ,[description]
           ,[is_enabled]
           ,[tenant_id]
           ,[app_id]
		   ,[is_admin])
		 VALUES
		   (@RoleName
		   ,@Description
		   ,@IsEnabled
		   ,@TenantId
		   ,@AppId
		   ,@IsAdminRole)


        SELECT TOP 1 @RoleId = role_id FROM tb_r_role 
		  WHERE role_name = @RoleName AND tenant_id = @TenantId AND app_id = @AppId
		  ORDER BY role_id DESC

        IF @RoleId IS NULL OR @RoleId = '' OR @RoleId = 0
			BEGIN
				SET @ErrorMsg = 'failed to insert role'
				GOTO immediately_end
			END
        
		INSERT INTO tb_p_permission
			(
				description,
				role_id,
				operation_id
			)
		SELECT
			DISTINCT
				NULL,
				@RoleId,
				OperationId
		FROM @OperationId

		SET @IsSuccess = 1;
		immediately_end:
		
		IF @IsSuccess = 0
			BEGIN
				ROLLBACK TRANSACTION
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

		THROW
    END CATCH;

    SET NOCOUNT, XACT_ABORT OFF;
END