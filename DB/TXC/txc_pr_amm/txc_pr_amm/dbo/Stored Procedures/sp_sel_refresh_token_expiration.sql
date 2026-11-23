CREATE PROCEDURE [dbo].[sp_sel_refresh_token_expiration]
	@user_id int,
	@app_id int,
	@access_token nvarchar(1000),
	@refresh_token nvarchar(1000)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  
		user_token_id AS UserTokenId,
		refresh_token_exp AS Expiration,
		is_active AS IsActive
	FROM tb_ut_user_token
	WHERE app_id = @app_id
		AND user_id = @user_id
		AND access_token = @access_token
		AND refresh_token = @refresh_token
END