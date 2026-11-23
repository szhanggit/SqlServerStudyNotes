CREATE PROCEDURE [dbo].[sp_sel_tenant]
	@tenant_id INT
AS
BEGIN	
	SELECT
		t.[tenant_id] AS TenantId,
		t.[tenant_code] AS TenantCode,
		t.[tenant_name] AS TenantName,
		t.[is_enabled] AS IsEnabled
	FROM dbo.tb_t_tenant t
	WHERE t.tenant_id = @tenant_id AND t.is_enabled = 1
END