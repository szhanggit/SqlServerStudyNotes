CREATE PROCEDURE [dbo].[sp_sel_user_basic_information_by_user_name]
	-- Add the parameters for the stored procedure here
	@UserName [nvarchar](250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT  
		user_id AS UserBasicInfoId, 
		user_name AS UserName, 
		user_status AS UserStatus
	FROM dbo.tb_u_user 
	WHERE user_name = @UserName
END