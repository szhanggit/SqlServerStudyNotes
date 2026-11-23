CREATE   PROCEDURE [dbo].[sp_sel_ref_tenants]
AS
BEGIN
	SELECT
		t.[tenant_id] AS TenantId,
		t.[tenant_name] AS TenantName
	FROM dbo.tb_t_tenant t
END