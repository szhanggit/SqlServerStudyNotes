CREATE PROCEDURE [dbo].[sp_sel_super_admin_users]
	
	@search NVARCHAR(250),
	@row_count INT,
	@page_offset INT,
	@role_status INT,
	@user_status INT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF Object_Id('Tempdb..#superadmins') Is Not Null
       DROP TABLE #superadmins

	SELECT 
	    ur.user_id "UserId",
		CONCAT(users.firstname,' ',users.lastname) "Name",
		users.user_name "UserName",
		users.email "Email",
		users.user_status "UserStatus",
	    roles.role_id "RoleId",
		roles.role_name "RoleName",
		roles.description "RoleDescription",
		ur.active_date "RoleActive",
		ur.expiration_date "RoleExpired",
		ur.created_on "CreatedDate",
		ur.role_status "RoleStatus",
		ur.created_by "CreatedBy"
	INTO #superadmins
	FROM tb_ur_user_role ur WITH(NOLOCK)
	INNER JOIN tb_r_role roles WITH(NOLOCK) ON roles.role_id = ur.role_id 
	INNER JOIN tb_u_user users WITH(NOLOCK) ON users.user_id = ur.user_id
	WHERE roles.role_id = 1
	
	SELECT * 
	FROM #superadmins t
	WHERE
	    (
			t.Name LIKE IIF(@search IS NULL OR @search = '', t.Name, CONCAT('%',@search,'%')) OR
			t.Email LIKE IIF(@search IS NULL OR @search = '', t.Email, CONCAT('%',@search,'%')) 		
		)
		 AND
		 t.UserStatus = IIF(@user_status IS NULL OR @user_status = 0, t.UserStatus, @user_status) AND
		 t.RoleStatus = IIF(@role_status IS NULL OR @role_status = 0, t.RoleStatus, @role_status)

	ORDER BY t.UserId
	OFFSET @page_offset ROWS FETCH NEXT @row_count ROWS ONLY

END