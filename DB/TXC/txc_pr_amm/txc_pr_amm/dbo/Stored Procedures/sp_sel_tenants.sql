CREATE   PROCEDURE [dbo].[sp_sel_tenants]
AS
BEGIN
	SELECT
		t.[tenant_id] AS TenantId,
		t.[tenant_code] AS TenantCode,
		t.[tenant_name] AS TenantName,
		t.[is_enabled] AS IsEnabled
	FROM dbo.tb_t_tenant t
END