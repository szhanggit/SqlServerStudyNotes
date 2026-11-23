CREATE PROCEDURE [dbo].[sp_sel_ref_app_tnt_roles_resource]
	@AppId INT,
	@TenantId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT  
		_role.role_id "RoleId",
		_role.role_name "RoleName",
		_res.resource_id "ResourceId",
		_res.resource_name "ResourceName",
		_ops.operation_id "OperationId",
		_ops.operation_name "OperationName"
	FROM tb_r_role _role
	INNER JOIN tb_p_permission _perm ON _role.role_id = _perm.role_id
	INNER JOIN tb_o_operation _ops ON _perm.operation_id = _ops.operation_id
	INNER JOIN tb_r_resource _res ON _ops.resource_id = _res.resource_id
	WHERE _role.tenant_id = @TenantId AND _role.app_id = @AppId
	
END