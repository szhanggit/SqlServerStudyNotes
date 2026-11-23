CREATE PROCEDURE [dbo].[sp_sel_token_payload_by_user]
	-- Add the parameters for the stored procedure here
	@user_id AS INT,
	@app_id AS INT,
	@is_super_admin AS BIT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    SET @is_super_admin = 0
	
	IF EXISTS (SELECT TOP 1  * FROM tb_ur_user_role WHERE user_id = 1 AND role_id = 1)
		BEGIN
		  SET @is_super_admin = 1
		END
	
	IF Object_Id('Tempdb..#user_app_tenant') Is Not Null
       Drop Table #user_app_tenant
	
	SELECT 
		uat.user_id AS UserId,
		uat.app_id AS AppId,
		uat.tenant_id AS TenantId
	INTO #user_app_tenant
	FROM tb_uat_user_app_tenant uat
	WHERE uat.user_id = @user_id AND uat.app_id = @app_id
	
	--SELECT * FROM #user_app_tenant

	IF Object_Id('Tempdb..#user_tenant_role') Is Not Null
       Drop Table #user_tenant_role
	
	SELECT 
		ur.role_id AS RoleId,
		ISNULL(r.tenant_id, 0) AS TenantId
	INTO #user_tenant_role
	FROM tb_ur_user_role ur
	LEFT JOIN tb_r_role r ON r.role_id = ur.role_id
	WHERE ur.user_id = @user_id AND (r.app_id = @app_id OR r.role_id = 1)

	--select * from #user_tenant_role

	SELECT 
		TokenAppsDto.AppId,
		TokenTenantsDto.tenant_id AS TenantId,
		TokenRolesDto.RoleId
	FROM #user_app_tenant TokenAppsDto
	LEFT JOIN tb_t_tenant TokenTenantsDto ON TokenAppsDto.TenantId = TokenTenantsDto.tenant_id
	LEFT JOIN #user_tenant_role TokenRolesDto ON TokenTenantsDto.tenant_id = TokenRolesDto.TenantId
	FOR JSON AUTO

END