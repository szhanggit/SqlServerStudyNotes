CREATE PROCEDURE [dbo].[sp_sel_application]
	@app_id INT
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
	WHERE a.app_id = @app_id AND a.is_enabled = 1
END