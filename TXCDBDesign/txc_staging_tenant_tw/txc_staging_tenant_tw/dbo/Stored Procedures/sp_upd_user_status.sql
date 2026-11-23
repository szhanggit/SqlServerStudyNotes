CREATE PROCEDURE [dbo].[sp_upd_user_status]
	-- Add the parameters for the stored procedure here
	@IsSuccess BIT OUTPUT,
	@ErrorMessage NVARCHAR(250) OUTPUT,

	@UserId INT,
	@UserStatus INT,
	@Editor nvarchar(250)
AS
BEGIN
	SET XACT_ABORT ON;
	BEGIN TRY
		
		BEGIN TRANSACTION;

		SET @IsSuccess = 0;
		SET @ErrorMessage = NULL;

		
		UPDATE dbo.tb_u_user 
		 SET user_status = @UserStatus
		WHERE user_id = @UserId

		IF @@ROWCOUNT = 0
			BEGIN
				SET @ErrorMessage = 'failed to update user status';
				GOTO stop_process;
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
			getdate(),
			@Editor,
			app_id,
			tenant_id,
			IIF(@UserStatus = 1, 'Unblocked', 'Blocked'),
			NULL,
			NULL,
			NULL
		FROM tb_uat_user_app_tenant
		WHERE user_id = @UserId
		
		SET @IsSuccess = 1

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
	END CATCH
	SET XACT_ABORT OFF;
END