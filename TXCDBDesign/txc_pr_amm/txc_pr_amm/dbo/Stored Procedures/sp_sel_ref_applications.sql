CREATE PROCEDURE [dbo].[sp_sel_ref_applications]

AS
BEGIN	
	SELECT
		a.[app_id] AS AppId,
		a.[app_name] AS AppName
	FROM dbo.tb_a_app a
END