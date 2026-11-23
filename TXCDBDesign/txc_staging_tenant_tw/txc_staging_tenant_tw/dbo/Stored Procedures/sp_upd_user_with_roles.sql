CREATE   PROCEDURE [dbo].[sp_upd_user_with_roles] 
	-- Add the parameters for the stored procedure 
	@UserId INT,
	@IsSuccess BIT OUTPUT,
	@ErrorMessage NVARCHAR(250) OUTPUT,
	
	@CreatedBy NVARCHAR(250),

	@UserRoles dbo.tvp_upd_user_roles READONLY,
	@UserAppTenants dbo.tvp_upd_user_app_tenant READONLY

AS
BEGIN

    SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;
       	
		SET @IsSuccess = 0;

		DECLARE @totalNewUserAppTenant int = (SELECT COUNT(*) FROM @UserAppTenants where UserTenantAppId = 0);
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
			TenantAppExpiration,
			TenantAppActive,
			TenantAppStatus
		FROM @UserAppTenants
		WHERE UserTenantAppId = 0

		SET @totalInsertedAppTenant = @@ROWCOUNT;

		IF @totalInsertedAppTenant <> @totalNewUserAppTenant
			BEGIN
				SET @ErrorMessage = 'failed to add new application tenant';
				GOTO stop_process;
			END

		--update user_app_tenant
		UPDATE tb_uat_user_app_tenant
			SET 
				expiration_date = tvp_uat.TenantAppExpiration,
				active_date = tvp_uat.TenantAppActive,
				uat_status = tvp_uat.TenantAppStatus
		FROM tb_uat_user_app_tenant uat
		INNER JOIN @UserAppTenants tvp_uat ON uat.uat_id = tvp_uat.UserTenantAppId AND uat.user_id = tvp_uat.UserId
		
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
			RoleId, 
			getdate(), 
			RoleExpiration,
			RoleActive,
			@CreatedBy,
			RoleStatus,
			1
		FROM @UserRoles
		WHERE UserRoleId = 0 AND IsAssigned = 1
		
		INSERT INTO tb_uh_user_history
		(
		    user_id,
			update_datetime,
			editor,
			app_id,
			tenant_id,
			action,
			details,
			active_date,
			expiration_date
		)
		SELECT
			@UserId,
			GETDATE(),
			@CreatedBy,
			AppId,
			TenantId,
			CASE
				WHEN UserRoleId = 0 AND IsAssigned = 1 THEN 'Added Role'
				WHEN UserRoleId <> 0 AND IsAssigned = 0 THEN 'Removed Role'
			END AS [action],
			_role.role_name,
            RoleActive,
			RoleExpiration
		FROM @UserRoles _tvp_ur
		INNER JOIN tb_r_role _role ON _tvp_ur.RoleId = _role.role_id
		WHERE (UserRoleId = 0 AND IsAssigned = 1) OR (UserRoleId <> 0 AND IsAssigned = 0);

		--insert altered expiry 

        IF Object_Id('Tempdb..#modified_user_role') Is Not Null
           DROP TABLE #modified_user_role
        SELECT
			_tvp_ur.UserRoleId,
			CASE
				WHEN (_ur.active_date IS NULL AND _tvp_ur.RoleActive IS NULL) OR (_ur.expiration_date IS NULL AND _tvp_ur.RoleActive IS NULL) THEN 0
				WHEN (_ur.active_date IS NOT NULL AND _tvp_ur.RoleActive IS NULL) OR (_ur.expiration_date IS NOT NULL AND _tvp_ur.RoleActive IS NULL) THEN 1
				WHEN (_ur.active_date IS NULL AND _tvp_ur.RoleActive IS NOT NULL) OR (_ur.expiration_date IS NULL AND _tvp_ur.RoleActive IS NOT NULL) THEN 1
				WHEN (
						_ur.active_date IS NOT NULL AND _tvp_ur.RoleActive IS NOT NULL AND
						CONVERT(DATE, _ur.active_date) = CONVERT(DATE, _tvp_ur.RoleActive) 
				     ) OR
					 (
						_ur.expiration_date IS NOT NULL AND _tvp_ur.RoleExpiration IS NOT NULL AND
						CONVERT(DATE, _ur.expiration_date) = CONVERT(DATE, _tvp_ur.RoleExpiration) 						
					 ) THEN 0
				ELSE 1
			END AS IsAlteredExpiry
		INTO #modified_user_role
		FROM @UserRoles _tvp_ur
		INNER JOIN tb_ur_user_role _ur ON _tvp_ur.UserRoleId = _ur.user_role_id
        WHERE _tvp_ur.UserRoleId <> 0 AND _tvp_ur.IsAssigned = 1

		INSERT INTO tb_uh_user_history
		(
			user_id,
			update_datetime,
			editor,
			app_id,
			tenant_id,
			action,
			details,
			active_date,
			expiration_date
		)
		SELECT
			@UserId,
			GETDATE(),
			@CreatedBy,
			AppId,
			TenantId,
			'Altered Expiry',
			_role.role_name,
            RoleActive,
			RoleExpiration
		FROM @UserRoles _tvp_ur
		INNER JOIN tb_r_role _role ON _tvp_ur.RoleId = _role.role_id
		WHERE _tvp_ur.UserRoleId IN (SELECT UserRoleId FROM #modified_user_role WHERE IsAlteredExpiry = 1)
		
		--update existing role
		UPDATE tb_ur_user_role
			SET 
				active_date = tvp_ur.RoleActive,
				expiration_date = tvp_ur.RoleExpiration,
				role_status = tvp_ur.RoleStatus,
				is_assigned = tvp_ur.IsAssigned
		FROM tb_ur_user_role ur
		INNER JOIN @UserRoles tvp_ur ON ur.user_role_id = tvp_ur.UserRoleId AND ur.user_id = tvp_ur.UserId

		IF @@ROWCOUNT = 0
			BEGIN
				SET @ErrorMessage = 'failed to add user history'
			END
		ELSE
			BEGIN
				SET @IsSuccess = 1;
			END

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

    SET XACT_ABORT OFF;
END