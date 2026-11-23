CREATE PROCEDURE [dbo].[sp_sel_roles_by_operation] 
	@OperationId INT
AS
BEGIN
	
	SET NOCOUNT ON;
    SELECT 
		[role].role_id "RoleId"
	FROM tb_a_app app
	INNER JOIN tb_m_module module ON app.app_id = module.app_id
	INNER JOIN tb_r_resource [resource] ON module.module_id = [resource].module_id
	INNER JOIN tb_o_operation operation ON resource.resource_id = operation.resource_id
	INNER JOIN tb_p_permission permission ON operation.operation_id = permission.operation_id
	INNER JOIN tb_r_role [role] ON permission.role_id = [role].role_id
	WHERE
	[app].is_enabled = 1 AND
	[resource].is_enabled = 1 AND
	operation.is_enabled = 1 AND
	[role].is_enabled = 1 AND
	operation.operation_id = @OperationId 	
	
END