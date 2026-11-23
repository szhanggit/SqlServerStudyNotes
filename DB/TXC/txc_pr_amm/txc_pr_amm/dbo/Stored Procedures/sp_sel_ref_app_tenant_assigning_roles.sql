CREATE PROCEDURE [dbo].[sp_sel_ref_app_tenant_assigning_roles]
	-- Add the parameters for the stored procedure here
	@TenantId INT,
	@AppId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.


    SELECT
	    DISTINCT
		0 "UserRoleId",
		_role.role_id "RoleId",
		_role.role_name "RoleName",
		_role.description "RoleDescription",
		null "RoleActive",
		null "RoleExpiration",
		_role.is_admin "IsAdminRole"
	FROM  tb_r_role _role
	INNER JOIN tb_p_permission _perm ON _role.role_id = _perm.role_id
	WHERE _role.app_id = @AppId AND _role.tenant_id = @TenantId AND _role.is_admin = 0
END