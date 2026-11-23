CREATE PROCEDURE [dbo].[sp_sel_ref_app_permission]
	-- Add the parameters for the stored procedure here
	@app_Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


    IF Object_Id('Tempdb..#resource') Is Not Null
       DROP TABLE #resource
	SELECT 
		resource.resource_id "ResourceId",
		resource.resource_name "ResourceName"
	INTO #resource
	FROM tb_a_app app
	LEFT JOIN tb_m_module module on app.app_id = module.app_id
	LEFT JOIN tb_r_resource resource on module.module_id = resource.module_id
	WHERE app.app_id = @app_Id


	SELECT 
		resource.ResourceName,
		Operations.operation_id "OperationId",
		Operations.operation_code "OperationCode",
		Operations.operation_name "OperationName"
	FROM #resource resource 
	LEFT JOIN tb_o_operation Operations
	ON resource.ResourceId = Operations.resource_id
	FOR JSON AUTO, INCLUDE_NULL_VALUES

END