CREATE PROCEDURE [dbo].[sp_upd_admin_user]
	-- Add the parameters for the stored procedure here
    @UserId INT,
	@IsSuccess BIT OUTPUT,
	@ErrorMessage NVARCHAR(250) OUTPUT,

	@CreatedBy NVARCHAR(250),

	@AdminAppTenants dbo.tvp_upd_admin_app_tenant READONLY
AS
BEGIN

 SET XACT_ABORT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
        
		SET @IsSuccess = 0;

		DECLARE @totalNewUserAppTenant int = (SELECT COUNT(*) FROM @AdminAppTenants where UserTenantAppId = 0);
		DECLARE @totalInsertedAppTenant int;
		
		--Add new UserAppTenants
		INSERT INTO tb_uat_user_app_tenant
		(
			user_id,
			app_id,
			tenant_id,
			created_on,
			expiration_date,
			active_date,
			uat_status
		)
		SELECT 
			UserId,
			AppId,
			TenantId,
			getdate(),
			ExpirationDate,
			ActiveDate,
			TenantAppStatus
		FROM @AdminAppTenants
		WHERE UserTenantAppId = 0 AND UserRoleId = 0

		SET @totalInsertedAppTenant = @@ROWCOUNT;

		IF @totalInsertedAppTenant <> @totalNewUserAppTenant
			BEGIN
				SET @ErrorMessage = 'failed to add new application tenant';
				GOTO stop_process;
			END

		--update user_app_tenant
		UPDATE tb_uat_user_app_tenant
			SET 
				expiration_date = tvp_uat.ExpirationDate,
				active_date = tvp_uat.ActiveDate,
				uat_status = tvp_uat.TenantAppStatus
		FROM tb_uat_user_app_tenant uat
		INNER JOIN @AdminAppTenants tvp_uat ON uat.uat_id = tvp_uat.UserTenantAppId AND uat.user_id = tvp_uat.UserId

		-- Add new User Roles
		INSERT INTO dbo.tb_ur_user_role 
		(
			user_id, 
			role_id, 
			created_on, 
			expiration_date,
			active_date,
			created_by,
			role_status,
			is_assigned
		)
		
		SELECT 
			UserId, 
			AdminRoleId, 
			getdate(), 
			ExpirationDate,
			ActiveDate,
			@CreatedBy,
			RoleStatus,
			1
		FROM @AdminAppTenants
		WHERE UserRoleId = 0

		UPDATE tb_ur_user_role
			SET 
				active_date = tvp_ur.ActiveDate,
				expiration_date = tvp_ur.ExpirationDate,
				role_status = tvp_ur.RoleStatus,
				is_assigned = tvp_ur.IsAssigned
		FROM tb_ur_user_role ur
		INNER JOIN @AdminAppTenants tvp_ur ON ur.user_role_id = tvp_ur.UserRoleId AND ur.user_id = tvp_ur.UserId

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
	END CATCH
 SET XACT_ABORT OFF;

END