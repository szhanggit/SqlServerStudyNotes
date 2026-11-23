CREATE PROCEDURE [dbo].[sp_sel_roles_with_details]
	@search NVARCHAR(250),
	@row_count INT,
	@page_offset INT,
	@app_id INT,
    @tenant_Id INT,
	@role_Id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    --remove category if finalize the new UI
	
    IF Object_Id('Tempdb..#role') Is Not Null
       DROP TABLE #role

	SELECT
		_app.app_name "Application",
		_role.role_id "RoleId",
		_role.role_name "RoleName",
		_resource.resource_id "ResourceId",
		_resource.resource_name "Resource",
		_operation.operation_name "Operation",
		_role.is_enabled "Status",
		_role.tenant_id "TenantId"
	INTO #role
	FROM tb_r_role _role 
	LEFT JOIN tb_p_permission _permission ON _role.role_id = _permission.role_id
	LEFT JOIN tb_o_operation _operation ON _permission.operation_id = _operation.operation_id
	LEFT JOIN tb_r_resource _resource ON _operation.resource_id = _resource.resource_id
	LEFT JOIN tb_a_app _app ON _role.app_id = _app.app_id
	WHERE
	    (
			_role.role_name LIKE IIF(@search IS NULL OR @search = '', _role.role_name, CONCAT('%',@search,'%')) OR
			_resource.resource_name LIKE IIF(@search IS NULL OR @search = '', _resource.resource_name, CONCAT('%',@search,'%')) OR
			_app.app_name LIKE IIF(@search IS NULL OR @search = '', _app.app_name, CONCAT('%',@search,'%')) 
		)
		AND
		 _role.app_id = IIF(@app_id IS NULL OR @app_id = 0, _role.app_id, @app_id) AND
		 _role.tenant_id = IIF(@tenant_Id IS NULL OR @tenant_Id = 0, _role.tenant_id, @tenant_Id) AND
		 _role.role_id = IIF(@role_Id IS NULL OR @role_Id = 0, _role.role_id, @role_Id)
	   AND _role.role_id <> 1
	   AND _resource.resource_id IS NOT NULL
	   AND _operation.operation_id IS NOT NULL
    

	SELECT
	    DISTINCT
		Application,
		RoleId,
		RoleName,
		ResourceId,
		Resource,
		STUFF((SELECT ', ' + a.Operation
          FROM #role a
          WHERE a.RoleId = b.RoleId AND a.ResourceId = b.ResourceId
          FOR XML PATH('')), 1, 1, '') [OperationDetails],
		Status,
		TenantId
	FROM #role b
	ORDER BY b.Application, b.RoleId, b.TenantId
	OFFSET @page_offset ROWS FETCH NEXT @row_count ROWS ONLY
END