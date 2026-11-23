CREATE PROCEDURE [dbo].[sp_sel_users_with_roles]
	-- Add the parameters for the stored procedure here
	@search NVARCHAR(250),
	@row_count INT,
	@page_offset INT,
	@total INT OUTPUT,
	@tenant_id INT,
	@app_id INT,
	@role_status INT,
	@user_status INT,
	@roles_id dbo.tvp_filter_roleId readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @role_count INT = (SELECT COUNT(RoleId) FROM @roles_id)

    IF Object_Id('Tempdb..#user_app_tenant') Is Not Null
       DROP TABLE #user_app_tenant
	SELECT 
	    users.user_id "UserId",
		users.user_name "UserName",
		users.firstname +' '+ users.lastname "Name",
		users.user_status "UserStatus",
		users.email "Email",
		tenants.tenant_name "Tenant",
		apps.app_name "Application",
		tenants.tenant_id "TenantId",
		apps.app_id "AppId"
	INTO  #user_app_tenant
	FROM tb_uat_user_app_tenant uat
	INNER JOIN tb_u_user users ON users.user_id = uat.user_id
	INNER JOIN tb_a_app apps ON apps.app_id = uat.app_id
	INNER JOIN tb_t_tenant tenants ON tenants.tenant_id = uat.tenant_id

	--SELECT * FROM #user_app_tenant

    IF Object_Id('Tempdb..#user_role') Is Not Null
       DROP TABLE #user_role

	SELECT 
	    ur.user_id "UserId",
	    roles.role_id "RoleId",
		roles.role_name "RoleName",
		ur.active_date "RoleActive",
		ur.expiration_date "RoleExpired",
		ur.role_status "RoleStatus",
		roles.description "RoleDescription",
		ur.created_on "CreatedDate",
		ur.created_by "CreatedBy",
		roles.tenant_id "TenantId",
		roles.app_id "AppId",
		roles.is_admin "IsAdmin"
	INTO #user_role
	FROM tb_ur_user_role ur
	INNER JOIN tb_r_role roles ON roles.role_id = ur.role_id

    IF Object_Id('Tempdb..#user') Is Not Null
       DROP TABLE #user

	SELECT
		users.UserId,
		users.UserName,
		users.Name,
	    users.UserStatus,
		users.Email,
		users.Tenant "Tenant",
		users.Application "Application",
		users.TenantId,
		users.AppId,
		roles.RoleName,
		roles.RoleActive,
		roles.RoleExpired,
		roles.RoleStatus,
		roles.RoleDescription,
		roles.CreatedDate,
		roles.CreatedBy,
		roles.RoleId,
		roles.IsAdmin 
	INTO #user
	FROM #user_app_tenant users
	CROSS APPLY
	(
		SELECT * FROM #user_role
		WHERE UserId = users.UserId AND TenantId = users.TenantId AND AppId = users.AppId
	) roles
	
	WHERE
	    (
			users.Name LIKE IIF(@search IS NULL OR @search = '', users.Name, CONCAT('%',@search,'%')) OR
			users.Email LIKE IIF(@search IS NULL OR @search = '', users.Email, CONCAT('%',@search,'%')) OR
			users.Tenant LIKE IIF(@search IS NULL OR @search = '', users.Tenant, CONCAT('%',@search,'%')) OR	
			roles.RoleName LIKE IIF(@search IS NULL OR @search = '', roles.RoleName, CONCAT('%',@search,'%')) 			
		)
		 AND
		 users.AppId = IIF(@app_id IS NULL OR @app_id = 0, users.AppId, @app_id) AND
		 users.TenantId = IIF(@tenant_Id IS NULL OR @tenant_Id = 0, users.TenantId, @tenant_Id) AND
		 users.UserStatus = IIF(@user_status IS NULL OR @user_status = 0, users.UserStatus, @user_status) AND
		 roles.RoleStatus = IIF(@role_status IS NULL OR @role_status = 0, roles.RoleStatus, @role_status)
		 AND
		 ( roles.RoleId IN (SELECT RoleId FROM @roles_id) 
		    OR roles.RoleId = ( CASE WHEN @role_count = 0 THEN roles.RoleId END)
		 )
	


	SELECT * FROM #user WHERE [UserId] NOT IN (SELECT UserId FROM #user WHERE IsAdmin = 1)
	ORDER BY UserId, AppId, TenantId
	OFFSET @page_offset ROWS FETCH NEXT @row_count ROWS ONLY
END