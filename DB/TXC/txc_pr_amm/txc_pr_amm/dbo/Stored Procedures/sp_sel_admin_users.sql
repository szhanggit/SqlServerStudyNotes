CREATE PROCEDURE [dbo].[sp_sel_admin_users]
	
	@search NVARCHAR(250),
	@row_count INT,
	@page_offset INT,
	@total INT OUTPUT,
	@tenant_id INT,
	@app_id INT,
	@role_status INT,
	@user_status INT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF Object_Id('Tempdb..#admins') Is Not Null
       DROP TABLE #admins

	SELECT 
	    ur.user_id "UserId",
		CONCAT(users.firstname,' ',users.lastname) "Name",
		users.user_name "UserName",
		users.email "Email",
		tenant.tenant_name "Tenant",
		app.app_name "Application",
		users.user_status "UserStatus",
	    roles.role_id "RoleId",
		roles.role_name "RoleName",
		roles.description "RoleDescription",
		ur.active_date "RoleActive",
		ur.expiration_date "RoleExpired",
		ur.created_on "CreatedDate",
		ur.role_status "RoleStatus",
		ur.created_by "CreatedBy",
		tenant.tenant_id "TenantId",
		app.app_id "AppId"
	INTO #admins
	FROM tb_ur_user_role ur
	INNER JOIN tb_r_role roles ON roles.role_id = ur.role_id AND roles.is_admin = 1
	INNER JOIN tb_uat_user_app_tenant uat ON uat.user_id = ur.user_id AND uat.tenant_id = roles.tenant_id AND uat.app_id = roles.app_id
	INNER JOIN tb_u_user users ON users.user_id = ur.user_id
	INNER JOIN tb_t_tenant tenant ON uat.tenant_id = tenant.tenant_id
	INNER JOIN tb_a_app app ON uat.app_id = app.app_id	
	
	SELECT * 
	FROM #admins t
	WHERE
	    (
			t.Name LIKE IIF(@search IS NULL OR @search = '', t.Name, CONCAT('%',@search,'%')) OR
			t.Email LIKE IIF(@search IS NULL OR @search = '', t.Email, CONCAT('%',@search,'%')) OR
			t.Tenant LIKE IIF(@search IS NULL OR @search = '', t.Tenant, CONCAT('%',@search,'%')) OR	
			t.RoleName LIKE IIF(@search IS NULL OR @search = '', t.RoleName, CONCAT('%',@search,'%')) 			
		)
		 AND
		 t.AppId = IIF(@app_id IS NULL OR @app_id = 0, t.AppId, @app_id) AND
		 t.TenantId = IIF(@tenant_Id IS NULL OR @tenant_Id = 0, t.TenantId, @tenant_Id) AND
		 t.UserStatus = IIF(@user_status IS NULL OR @user_status = 0, t.UserStatus, @user_status) AND
		 t.RoleStatus = IIF(@role_status IS NULL OR @role_status = 0, t.RoleStatus, @role_status)

	ORDER BY t.UserId, t.AppId, t.TenantId
	OFFSET @page_offset ROWS FETCH NEXT @row_count ROWS ONLY

END