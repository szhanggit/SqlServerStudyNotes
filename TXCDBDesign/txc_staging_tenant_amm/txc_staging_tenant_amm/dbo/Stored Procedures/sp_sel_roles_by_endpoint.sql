CREATE PROCEDURE [dbo].[sp_sel_roles_by_endpoint]
	@Controller NVARCHAR(250),
	@Action NVARCHAR(250),
	@Key NVARCHAR(64)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT DISTINCT p.role_id FROM dbo.tb_aai_api_action_info aai WITH(NOLOCK) 
	JOIN dbo.tb_aom_api_operation_mapping aom WITH(NOLOCK) ON aai.api_info_id = aom.api_info_id
	JOIN dbo.tb_o_operation o WITH(NOLOCK) ON aom.operation_Id = o.operation_Id
	JOIN dbo.tb_p_permission p WITH(NOLOCK) ON o.operation_id = p.operation_id
	JOIN dbo.tb_r_role r WITH(NOLOCK) ON p.role_id = r.role_id
	WHERE aai.controller_name = @Controller
	AND aai.action_name = @Action
	AND aai.key_value = @Key
	AND r.is_enabled = 1
	
END