CREATE   PROCEDURE [dbo].[sp_ins_user_with_roles] 
	@UserId INT OUTPUT,
	@IsSuccess BIT OUTPUT,
	@ErrorMessage NVARCHAR(250) OUTPUT,
	
	@UserName NVARCHAR(250),
	@Email NVARCHAR(500),
	@FirstName NVARCHAR(200),
	@LastName NVARCHAR(200),
	@CheckSum NVARCHAR(256),
	@IsAdUser BIT ,
	@UserStatus INT,

	@CreatedBy NVARCHAR(250),

	@UserRoles dbo.tvp_ins_user_roles_by_username READONLY


AS
BEGIN
	SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;
		
			DECLARE @insert_user_app int = 0;
			DECLARE @insert_user_role int = 0;

			SET @UserId = 0;
			SET @IsSuccess = 0;
			SET @ErrorMessage = NULL;

			--validate of theirs any admin or super admin role

			IF EXISTS 
			(
				SELECT
					*
				FROM @UserRoles aur 
				JOIN tb_r_role [role] ON aur.RoleId = [role].role_id
				WHERE aur.RoleId = 1 OR [role].is_admin = 1 			
			)

				BEGIN
					SET @IsSuccess = 0;
					SET @ErrorMessage = 'Super Admin / Admin Role not allowed';
					GOTO stop_process;
				END
			
			IF NOT EXISTS (SELECT TOP 1 * FROM tb_u_user WHERE user_name = @UserName OR email = @Email) 
			BEGIN
				INSERT INTO dbo.tb_u_user 
				(
					user_name, 
					email, 
					firstname, 
					lastname, 
					creation_time, 
					check_sum, 
					is_ad_user,
					user_status
				)
				VALUES
			    (
					@UserName,
					@Email,
					@FirstName,
					@LastName,
					GETDATE(),
					@CheckSum,
					@IsAdUser,
					@UserStatus
				)
				
				SELECT @UserId = user_id FROM tb_u_user WHERE user_name = @UserName AND email = @Email

				IF @UserId IS NOT NULL AND @UserId > 0
					BEGIN
						--if success full insert the user then add user tenant app
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
							DISTINCT
							@UserId,
							AppId,
							TenantId,
							getdate(),
							TenantAppExpiration,
							TenantAppActive,
							TenantAppStatus
						FROM @UserRoles

						SET @insert_user_app = @@ROWCOUNT

						--insert user roles
						INSERT INTO tb_ur_user_role
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
							@UserId,
							RoleId,
							GETDATE(),
							RoleExpiration,
							RoleActive,
							@CreatedBy,
							RoleStatus,
							1
						FROM @UserRoles

						SET @insert_user_role = @@ROWCOUNT

						IF @insert_user_app = 0 OR @insert_user_role = 0
							BEGIN
								SET @ErrorMessage = 'failed to add user role'
							END
						ELSE
							BEGIN
								SET @IsSuccess = 1;
							END

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
							'Added Role',
							_role.role_name,
                            RoleActive,
							RoleExpiration
						FROM @UserRoles _tvp_ur
						INNER JOIN tb_r_role _role ON _tvp_ur.RoleId = _role.role_id

						IF @@ROWCOUNT = 0
							BEGIN
								SET @ErrorMessage = 'failed to add user history'
							END
						ELSE
							BEGIN
								SET @IsSuccess = 1;
							END

					END
				ELSE
					BEGIN
						SET @ErrorMessage = 'failed to add user'
					END
			END
			ELSE
				BEGIN
					SET @ErrorMessage = 'user already exists'
				END
	
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

		THROW
    END CATCH;

    SET XACT_ABORT OFF;
END