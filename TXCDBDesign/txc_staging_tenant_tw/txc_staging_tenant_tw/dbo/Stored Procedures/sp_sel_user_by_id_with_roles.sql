CREATE PROCEDURE [dbo].[sp_sel_user_by_id_with_roles]
	-- Add the parameters for the stored procedure here
	@user_id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    IF Object_Id('Tempdb..#user_app_tenant') Is Not Null
       DROP TABLE #user_app_tenant
	SELECT 
		users.user_id "UserId",
		users.user_name "UserName",
	    users.firstname +' '+ users.lastname "Name",
		users.is_ad_user "UserType",
		users.email "Email",
		uat_id "UatId",
		uat.tenant_id "TenantId",
		uat.app_id "AppId",
		apps.app_name "Application",
		tenants.tenant_name "Tenant",
		uat.active_date "TenantActive",
		uat.expiration_date "TenantExpired",
		uat.uat_status "TenantAppStatus"
	INTO  #user_app_tenant
	FROM tb_uat_user_app_tenant uat
	INNER JOIN tb_u_user users ON users.user_id = uat.user_id
	INNER JOIN tb_a_app apps ON apps.app_id = uat.app_id
	INNER JOIN tb_t_tenant tenants ON tenants.tenant_id = uat.tenant_id 
	WHERE uat.user_id = @user_id

	--select * from #user_app_tenant

    IF Object_Id('Tempdb..#user_role') Is Not Null
       DROP TABLE #user_role

    SELECT
	    DISTINCT
		_uat.UserId "UserId",
		_uat.TenantId "TenantId",
		_uat.AppId "AppId",
	    ISNULL(_ur.user_role_id,0) "UserRoleId",
		_role.role_id "RoleId",
		_role.role_name "RoleName",
		_role.description "RoleDescription",
		_ur.active_date "RoleActive",
		_ur.expiration_date "RoleExpired",
		IIF(_ur.user_role_id IS NULL OR _ur.user_role_id = 0,2,_ur.role_status) "RoleStatus",
		ISNULL(_ur.is_assigned,0) "IsAssigned",
		_role.is_admin "IsAdmin"
	INTO #user_role
	FROM #user_app_tenant _uat
	INNER JOIN tb_r_role _role ON _uat.AppId = _role.app_id AND _uat.TenantId = _role.tenant_id
	INNER JOIN tb_p_permission _permission ON _role.role_id = _permission.role_id
	LEFT JOIN tb_ur_user_role _ur ON _role.role_id = _ur.role_id AND _ur.user_id = _uat.UserId AND _uat.TenantId = _role.tenant_id

	--SELECT * FROM #user_role order by RoleId
    IF Object_Id('Tempdb..#user') Is Not Null
       DROP TABLE #user

	SELECT
	    users.UserId,
		users.UserName,
		users.Name,
		users.UserType,
		users.Email,
		users.UatId,
		users.AppId,
		users.TenantId,
		users.Tenant "Tenant",
		users.Application "Application",
		users.TenantActive,
		users.TenantExpired,
		users.TenantAppStatus,
		roles.UserRoleId,
		roles.RoleId,
		roles.RoleName,
		roles.RoleDescription,
		roles.RoleActive,
		roles.RoleExpired,
		roles.RoleStatus,
		roles.IsAssigned,
		roles.IsAdmin,
	    IIF(UserRoleId <> 0 AND roles.IsAdmin = 1, 1,0) "IsAdminRole"
	INTO #user
	FROM #user_app_tenant users
	CROSS APPLY
	(
		SELECT * FROM #user_role
		WHERE UserId = users.UserId AND TenantId = users.TenantId AND AppId = users.AppId
	) roles
	order by UatId,RoleId

	--SELECT * FROM #user

	SELECT * FROM #user WHERE UserId NOT IN (SELECT UserId FROM #user where UserRoleId != 0 AND IsAdminRole = 1)
END