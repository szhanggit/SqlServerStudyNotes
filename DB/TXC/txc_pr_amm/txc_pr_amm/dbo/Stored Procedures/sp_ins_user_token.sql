CREATE PROCEDURE [dbo].[sp_ins_user_token]
	-- Add the parameters for the stored procedure here
	@user_id int,
	@app_id int,
	@access_token nvarchar(1000),
	@refresh_token nvarchar(1000),
	@refresh_token_exp datetime,
	@created_on datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT, XACT_ABORT ON;

	BEGIN TRY
		BEGIN TRANSACTION;

			UPDATE tb_ut_user_token SET is_active = 0
			WHERE user_id = @user_id AND app_id = @app_id

			INSERT INTO tb_ut_user_token
			(
				user_id,
				app_id,
				access_token,
				refresh_token,
				refresh_token_exp,
				is_active,
				created_on
			)
			VALUES
			(
				@user_id,
				@app_id,
				@access_token,
				@refresh_token,
				@refresh_token_exp,
				1,
				@created_on
			);

		COMMIT TRANSACTION;
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