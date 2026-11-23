CREATE PROCEDURE [dbo].[sp_sel_user_history_by_id_app_tenant]
	-- Add the parameters for the stored procedure here
	@UserId INT,
	@AppId INT,
	@TenantId INT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
		_user.user_name "UserName",
		_uh.update_datetime "EditDateTime",
		_uh.editor "Editor",
		_tenant.tenant_name "Tenant",
		_app.app_name "Application",
		CASE
			WHEN _uh.details IS NOT NULL AND _uh.details <> '' AND TRIM(_uh.details) <> '' OR TRIM(_uh.details) IS NOT NULL THEN CONCAT(_uh.[action],' / ',_uh.details)
			ELSE _uh.[action]
		END AS "ActionDetails",
		CASE
			WHEN _uh.active_date IS NOT NULL AND _uh.expiration_date IS NOT NULL THEN CONCAT(CONVERT(VARCHAR(20),_uh.active_date,107), ' / ' ,CONVERT(VARCHAR(20),_uh.expiration_date,107))
			ELSE NULL
		END AS "AccessDuration"
	FROM tb_uh_user_history _uh
	INNER JOIN tb_u_user _user ON _uh.user_id = _user.user_id
	INNER JOIN tb_a_app _app ON _uh.app_id = _app.app_id
	INNER JOIN tb_t_tenant _tenant ON _uh.tenant_id = _tenant.tenant_id
	WHERE _uh.user_id = @UserId AND _uh.tenant_id = @TenantId AND _uh.app_id = @AppId
END