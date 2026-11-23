CREATE PROCEDURE [dbo].[sp_sel_user_claim_test] 
	@Email NVARCHAR(250),
	@UserId INT OUTPUT
AS
BEGIN
	
	SET NOCOUNT ON;
	
	
	SET @UserId = 0;

	SELECT @UserId = user_id FROM tb_u_user where email = @email

	IF @UserId IS NULL
		BEGIN	
			SET @UserId = 0;
		END

	IF Object_Id('Tempdb..#tmp_user_role') Is Not Null
       Drop Table #tmp_user_role

	SELECT 
		 u.[user_id] "UserId"
		,a.app_id "AppId"
		,t.tenant_id "TenantId"
		,ur.role_id "RoleId"
	INTO #tmp_user_role
	FROM dbo.tb_u_user u WITH (NOLOCK)
	JOIN dbo.tb_ur_user_role ur WITH(NOLOCK) ON u.[user_id] = ur.[user_id]
	JOIN dbo.tb_uat_user_app_tenant uat WITH(NOLOCK) ON u.[user_id] = uat.[user_id]
	JOIN dbo.tb_a_app a WITH(NOLOCK) ON a.app_id = uat.app_id
	JOIN dbo.tb_t_tenant t WITH(NOLOCK) ON t.tenant_id = uat.tenant_id
	WHERE 
		u.email = @email
	AND u.user_status = 1  --active
	AND uat.uat_status = 1 --active
	AND ur.role_status = 1 --active
	AND ur.role_id != 1
	AND a.is_enabled = 1
	AND t.is_enabled = 1
	UNION ALL
	SELECT
		[user_id],
		0,
		0,
		role_id
	FROM dbo.tb_ur_user_role 
	WHERE [user_id] = @UserId
	AND role_id = 1 --super admin role is fixed to 1

	IF Object_Id('Tempdb..#tmp_matrix') Is Not Null
       Drop Table #tmp_matrix

	SELECT  
		ur.TenantId,
		o.operation_id "OperationId",
		ur.RoleId,
		m.module_id "ModuleId",
		rs.resource_id "ResourceId"
	INTO #tmp_matrix
	FROM #tmp_user_role ur
	JOIN dbo.tb_p_permission p WITH(NOLOCK) ON ur.RoleId = p.role_id
	JOIN dbo.tb_o_operation o WITH(NOLOCK) ON o.operation_id = p.operation_id
	JOIN dbo.tb_r_resource rs WITH(NOLOCK) ON rs.resource_id = o.resource_id
	JOIN dbo.tb_m_module m WITH(NOLOCK) ON m.module_id = rs.module_id
	WHERE 
		o.is_enabled = 1
	AND rs.is_enabled = 1
	AND m.module_id = 1
    ORDER BY RoleId
	
	--SELECT * FROM #tmp_matrix
    SELECT DISTINCT ModuleId FROM #tmp_matrix
	SELECT DISTINCT ResourceId FROM #tmp_matrix
	SELECT DISTINCT OperationId FROM #tmp_matrix
	SELECT DISTINCT RoleId FROM #tmp_matrix
END