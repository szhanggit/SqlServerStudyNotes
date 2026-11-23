CREATE PROCEDURE  [dbo].[sp_ins_super_admin_user]
	@UserName NVARCHAR(250),
	@Email NVARCHAR(500),
	@FirstName NVARCHAR(200),
	@LastName NVARCHAR(200),
	@Check_Sum NVARCHAR(250),
	@RoleId INT,
	@UserBasicInfoId INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		SET NOCOUNT ON;

	SET NOCOUNT, XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;
			INSERT INTO dbo.tb_ubi_user_basic_information 
			(
				[user_name],
				email,
				firstname,
				lastname,
				creation_time,
				check_sum,
				is_active
			)
			VALUES
			(
				@UserName,
				@Email,
				@FirstName,
				@LastName,
				getdate(),
				@Check_Sum,
				1
			);


		    SELECT  
				@UserBasicInfoId = user_basic_info_id
			FROM dbo.tb_ubi_user_basic_information
			WHERE email = @Email AND [user_name] = @UserName

		    INSERT INTO dbo.tb_ur_user_role 
			(
			  [user_id],
			  role_id,
			  tenant_id
			)
			VALUES
			(
				@UserBasicInfoId,
				@RoleId,
				null
			);



        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH 

       IF @@TRANCOUNT > 0
       BEGIN
          ROLLBACK TRANSACTION
       END;

	   THROW;
    END CATCH;

    SET NOCOUNT, XACT_ABORT OFF;

END