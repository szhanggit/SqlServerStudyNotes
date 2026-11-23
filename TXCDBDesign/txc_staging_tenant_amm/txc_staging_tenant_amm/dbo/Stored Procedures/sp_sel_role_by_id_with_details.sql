CREATE PROCEDURE [dbo].[sp_sel_role_by_id_with_details]
	-- Add the parameters for the stored procedure here
	@RoleId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DECLARE @RoleName NVARCHAR(100);
	DECLARE @TenantId INT;
    DECLARE @AppId INT;
	DECLARE @Description NVARCHAR(255);
	DECLARE @Status BIT;
	DECLARE @IsAdmin BIT;



    IF Object_Id('Tempdb..#role_permission') Is Not Null
       DROP TABLE #role_permission
	SELECT
		_role.role_id "RoleId",
		_role.role_name "RoleName",
		_role.tenant_id "TenantId",
		_role.app_id "AppId",
		_role.description "Description",
		_role.is_enabled "Status",
		_role.is_admin "IsAdmin",
		_perm.permission_id "PermissionId",
		_perm.operation_id "OperationId"
	INTO #role_permission
	FROM
	tb_r_role _role 
	LEFT JOIN tb_p_permission _perm ON _role.role_id = _perm.role_id
	WHERE _role.role_id = @RoleId

	SELECT
		@AppId = AppId,
		@TenantId = TenantId,
		@RoleName = RoleName,
		@Status = Status,
		@IsAdmin = IsAdmin,
		@Description = Description
	FROM #role_permission

    IF Object_Id('Tempdb..#resource_operation') Is Not Null
       DROP TABLE #resource_operation
	SELECT 
		resource.resource_id "ResourceId",
		resource.resource_name "ResourceName",
		operation.operation_id "OperationId",
		operation.operation_name "OperationName"
	INTO #resource_operation
	FROM tb_a_app app
	INNER JOIN tb_m_module module on app.app_id = module.app_id
	INNER JOIN tb_r_resource resource on module.module_id = resource.module_id
	INNER JOIN tb_o_operation operation on resource.resource_id = operation.resource_id
	WHERE app.app_id = @AppId

	--SELECT * FROM #resource_operation

    IF Object_Id('Tempdb..#merge') Is Not Null
       DROP TABLE #merge

	SELECT
		@RoleId "RoleId",
		@RoleName "RoleName",
		@Description "Description",
		@Status "Status",
		@IsAdmin "IsAdmin",
		@TenantId "TenantId",
		@AppId "AppId",
		_rs.ResourceName,
		_rs.OperationId,
		_rs.OperationName "OperationName",
		IIF(_rp.PermissionId IS NULL, 0, _rp.PermissionId) "PermissionId",
        IIF(_rp.PermissionId IS NULL OR _rp.PermissionId = 0, 0, 1) "IsSelected"
	INTO #merge
	FROM #role_permission _rp
	RIGHT JOIN #resource_operation _rs ON _rp.OperationId = _rs.OperationId 

	SELECT * FROM #merge
END