CREATE PROCEDURE [dbo].[sp_ins_user_admin] 
	-- Add the parameters for the stored procedure here
	@UserName NVARCHAR(250),
	@Email NVARCHAR(500),
	@FirstName NVARCHAR(200),
	@LastName NVARCHAR(200),
	@IsAdUser BIT ,
	@UserStatus INT,

	@CreatedBy NVARCHAR(250),
	
	@UserRoles dbo.tvp_ins_admin_user_roles_by_username READONLY,
	
	@UserId INT OUTPUT,
	@IsSuccess BIT OUTPUT,
	@ErrorMsg NVARCHAR(250) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    SET XACT_ABORT ON;
	
	BEGIN TRY
		BEGIN TRANSACTION;

			DECLARE @insert_user_app int = 0;
			DECLARE @insert_user_role int = 0;

			SET @UserId = 0;
			SET @IsSuccess = 0;
			SET @ErrorMsg = NULL;

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
						null,
						@IsAdUser,
						@UserStatus
					)
				
					SELECT @UserId = user_id FROM tb_u_user WHERE user_name = @UserName AND email = @Email;

						IF @UserId > 0
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
									ExpirationDate,
									ActiveDate,
									RoleStatus
								FROM @UserRoles;

								SET @insert_user_app = @@ROWCOUNT

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
									ExpirationDate,
									ActiveDate,
									@CreatedBy,
									RoleStatus,
									1
								FROM @UserRoles;

								SET @insert_user_role = @@ROWCOUNT

								IF @insert_user_app = 0 OR @insert_user_role = 0
									BEGIN
										SET @ErrorMsg = 'failed to add user role';
									END
								ELSE
									BEGIN
										SET @IsSuccess = 1;
									END
							END
						ELSE
							BEGIN
								SET @ErrorMsg = 'failed to add user'
							END
				END
			ELSE
				BEGIN
					SET @ErrorMsg = 'user already exists';
				END

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
	END CATCH

	SET XACT_ABORT OFF;
END