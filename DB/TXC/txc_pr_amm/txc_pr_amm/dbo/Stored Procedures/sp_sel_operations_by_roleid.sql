CREATE PROCEDURE [dbo].[sp_sel_operations_by_roleid]
	-- Add the parameters for the stored procedure here
	@role_id INT
AS

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

IF Object_Id('Tempdb..#role_operation') Is Not Null
    DROP TABLE #role_operation
SELECT
	_role.role_id "RoleId",
	_op.operation_id "OperationId",
	_op.operation_name "OperationName"
INTO #role_operation
FROM tb_o_operation _op 
LEFT JOIN tb_p_permission _perm ON _perm.operation_id = _op.operation_id
LEFT JOIN tb_r_role _role ON _role.role_id = _perm.role_id
WHERE _op.is_enabled = 1 AND _role.is_enabled = 1 AND _role.role_id = @role_id
SELECT * FROM #role_operation Order by OperationId