CREATE PROCEDURE [dbo].[sp_sel_ref_app_tenant_roles]
	-- Add the parameters for the stored procedure here
	@TenantId INT,
	@AppId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    SELECT
	    DISTINCT
		_role.role_id "RoleId",
		_role.role_name "RoleName",
		_role.is_admin "IsAdminRole"
	FROM  tb_r_role _role
	WHERE 
	_role.app_id = IIF(@AppId IS NULL OR @AppId = 0, _role.app_id, @AppId) AND 
	_role.tenant_id =  IIF(@TenantId IS NULL OR @TenantId = 0, _role.tenant_id, @TenantId)
	AND _role.role_id <> 1 AND _role.is_admin = 0
END