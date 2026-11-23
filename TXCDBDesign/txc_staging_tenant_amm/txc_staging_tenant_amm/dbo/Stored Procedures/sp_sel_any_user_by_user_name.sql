CREATE PROCEDURE [dbo].[sp_sel_any_user_by_user_name]
	@UserName NVARCHAR (250)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SET NOCOUNT ON;
	
	IF(EXISTS(SELECT [user_id] FROM dbo.tb_u_user where [user_name] = @UserName) OR EXISTS(SELECT [user_id] FROM dbo.tb_u_user where email = @UserName))
		BEGIN
			SELECT 1;
		END
	ELSE
		BEGIN
			SELECT 0;
		END
END