CREATE PROCEDURE [dbo].[sp_sel_ref_assigning_operaton]
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
		res.ResourceName,
		ops.operation_id "OperationId",
		ops.operation_code "OperationCode",
		ops.operation_name "OperationName",
		ops.[classification] "Classification",
		0 "IsSelected"
	FROM #resource res
	JOIN dbo.tb_o_operation ops on res.ResourceId = ops.resource_id
END