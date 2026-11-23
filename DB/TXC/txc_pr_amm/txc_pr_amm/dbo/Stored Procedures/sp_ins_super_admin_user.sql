CREATE PROCEDURE  [dbo].[sp_ins_super_admin_user]
	@UserName NVARCHAR(250),
	@Email NVARCHAR(500),
	@FirstName NVARCHAR(200),
	@LastName NVARCHAR(200),
	@Check_Sum NVARCHAR(250),
	@RoleId INT,
	@CreationTime DATETIME,
	@UserBasicInfoId INT OUTPUT,
	@IsSuccess BIT OUTPUT,
	@ErrorMsg NVARCHAR(250) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		SET NOCOUNT ON;

	SET NOCOUNT, XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;
			
			SET @IsSuccess = 0;
			SET @ErrorMsg = NULL;
			
			IF NOT EXISTS (SELECT TOP 1 * FROM tb_u_user WHERE user_name = @UserName AND email = @Email)
				BEGIN
						INSERT INTO dbo.tb_u_user 
							(
								[user_name],
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
								@CreationTime,
								@Check_Sum,
								1,
								1
							);

							SELECT  
								@UserBasicInfoId = user_id
							FROM dbo.tb_u_user
							WHERE email = @Email AND [user_name] = @UserName;
							
							IF @UserBasicInfoId > 0
								BEGIN
									INSERT INTO dbo.tb_ur_user_role 
									(
									  [user_id],
									  role_id,
									  created_on,
									  expiration_date,
									  active_date,
									  created_by,
									  role_status,
									  is_assigned
									)
									VALUES
									(
										@UserBasicInfoId,
										@RoleId,
										@CreationTime,
										null,
										@CreationTime,
										'',
										1,
										1
									);
									IF @@ROWCOUNT = 0
										BEGIN
											SET @ErrorMsg = 'failed to insert role';
											GOTO stop_process;
										END
								END
							ELSE
								BEGIN
									SET @ErrorMsg = 'failed to add super admin';
									GOTO stop_process;
								END
				END
			ELSE
				BEGIN					
					SET @ErrorMsg = 'user already exists';
					GOTO stop_process;
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

    SET NOCOUNT, XACT_ABORT OFF;

END