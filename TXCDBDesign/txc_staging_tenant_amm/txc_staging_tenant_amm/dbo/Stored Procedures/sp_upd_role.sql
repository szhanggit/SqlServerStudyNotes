CREATE PROCEDURE [dbo].[sp_upd_role]
	 @RoleId	 		int,
	 @RoleName 			nvarchar(100),
	 @Description 		nvarchar(255) = NULL,
	 @IsEnabled			bit,
	 @TenantId			int,
	 @AppId				int,
	 @IsAdminRole       bit,
	 @NewOperationId       tvp_ins_role_operation_id readonly,
	 @DelOperationId       tvp_ins_role_operation_id readonly,
	 @IsSuccess         bit output,
	 @ErrorMsg          nvarchar(250) output
	 
AS
BEGIN
    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY

	BEGIN TRANSACTION

		SET @IsSuccess = 0;
		SET @ErrorMsg = NULL;

		DECLARE @role_cat_id int
		
		UPDATE [dbo].[tb_r_role]
		   SET [role_name] = @RoleName
			  ,[description] = @Description
			  ,[is_enabled] = @IsEnabled
			  ,[tenant_id] = @TenantId
			  ,[app_id] = @AppId
			  ,[is_admin] = @IsAdminRole
		 WHERE [role_id] = @RoleId

		 DELETE FROM tb_p_permission
		 WHERE role_id = @RoleId 
		 AND operation_id IN (SELECT OperationId FROM @DelOperationId)

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
		FROM @NewOperationId
		
		
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