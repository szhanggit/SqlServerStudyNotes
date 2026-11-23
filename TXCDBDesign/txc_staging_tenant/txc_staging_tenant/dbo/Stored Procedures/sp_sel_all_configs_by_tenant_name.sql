CREATE PROCEDURE [dbo].[sp_sel_all_configs_by_tenant_name]
	@TenantName varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT [tenant_id] 'TenantId',
			[configtype] 'ConfigType',
			[configname] 'ConfigName',
			[version] 'Version',
			[value] 'Value',
			[comment] 'Comment'
	FROM tb_tc_tenant_config Config
	INNER JOIN tb_tbi_tenant_basic_information Tenant
	ON Config.tenant_id = Tenant.tenant_basic_info_id
	WHERE Tenant.[name] = @TenantName

END