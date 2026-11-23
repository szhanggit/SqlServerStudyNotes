CREATE   PROCEDURE [dbo].[sp_sel_applications]
AS
BEGIN
	SELECT
		a.[app_id] AS AppId,
		a.[app_code] AS AppCode,
		a.[app_key] AS AppKey,
		a.[app_name] AS AppName,
		a.[description] AS Description,
		a.[is_enabled] AS IsEnabled,
		a.[is_multitenant] AS IsMultiTenant
	FROM dbo.tb_a_app a
END