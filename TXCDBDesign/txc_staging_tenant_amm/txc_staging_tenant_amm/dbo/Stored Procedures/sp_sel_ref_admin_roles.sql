CREATE PROCEDURE [dbo].[sp_sel_ref_admin_roles]
	@tenant_Id INT,
	@app_id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Do not return Super Admin Role
	SELECT 
	    TOP 1
		roles.role_id "AdminRoleId",
		roles.role_name "RoleName"
	FROM tb_r_role roles 
	WHERE roles.tenant_id = @tenant_Id AND roles.app_id = @app_id AND roles.is_admin = 1 AND roles.is_enabled = 1
END