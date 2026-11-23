CREATE PROCEDURE [dbo].[sp_sel_all_keys]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT key_name "KeyName", key_value "KeyValue", last_validate_time "LastValidateTime" FROM [dbo].[tb_def_auth_key]
	
    SET NOCOUNT OFF;
END