
-- =============================================
-- Author:		Knight YAO
-- Create date: 2014/05/08
-- Description:	Sync User Information
-- =============================================
CREATE PROCEDURE [dbo].[spSyncUserInfo] 
   @PartnerCode NVARCHAR(30)
	,@PartnerUserId VARCHAR(50)
	,@Email NVARCHAR(100)
	,@Mobile VARCHAR(30)
	,@Status INT
	,@Version INT
	,@OperationCode INT
	,@ResponseCode VARCHAR(4) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRAN

	IF @OperationCode = 1
	BEGIN
		INSERT INTO Member (
			PartnerCode
			,PartnerUserId
			,Email
			,Mobile
			,[Status]
			,CreatedOn
			,LastModifiedOn
			,[Version]
			)
		VALUES (
			@PartnerCode
			,@PartnerUserId
			,@Email
			,@Mobile
			,@Status
			,GETDATE()
			,GETDATE()
			,1
			)

		IF @@ROWCOUNT = 1
		BEGIN
			DECLARE @MemberId NUMERIC(18, 0) = SCOPE_IDENTITY()

			INSERT INTO MemberAccount (
				AccountNumber
				,AccountType
				,MemberId
				,ProgramId
				)
			SELECT TOP 1 a.AccountNumber
				,'G' AS AccountType
				,@MemberId AS MemberId
				,a.ProgramId
			FROM Account a
			INNER JOIN SGAccountTypeProductMapping m ON a.ProductId = m.ProductId
			LEFT JOIN MemberAccount ma ON a.AccountNumber = ma.AccountNumber
				AND a.ProgramId = ma.ProgramId
			WHERE m.AccountType = 'G' 
				AND m.IsMainAccount = 1
				AND ma.AccountNumber IS NULL
			
			UNION
			
			SELECT TOP 1 a.AccountNumber
				,'P'
				,@MemberId
				,a.ProgramId
			FROM Account a
			INNER JOIN SGAccountTypeProductMapping m ON a.ProductId = m.ProductId
			LEFT JOIN MemberAccount ma ON a.AccountNumber = ma.AccountNumber
				AND a.ProgramId = ma.ProgramId
			WHERE m.AccountType = 'P' 
				AND m.IsMainAccount = 1
				AND ma.AccountNumber IS NULL

			IF @@ROWCOUNT = 2
			BEGIN
				SET @ResponseCode = '0000'

				COMMIT TRAN
			END
			ELSE
			BEGIN
				SET @ResponseCode = '9999'

				ROLLBACK TRAN
			END
		END
		ELSE
		BEGIN
			SET @ResponseCode = '9999'

			ROLLBACK TRAN
		END
	END
	ELSE IF @OperationCode = 2
	BEGIN
		UPDATE Member
		SET Email = IIF(ISNULL(@Email, '') = '', Email, @Email)
			,Mobile = IIF(ISNULL(@Mobile, '') = '', Mobile, @Mobile)
			,[Status] = @Status
			,LastModifiedOn = GETDATE()
			,[Version] = [Version] + 1
		WHERE PartnerCode = @PartnerCode
			AND PartnerUserId = @PartnerUserId
			AND [Version] = @Version

		IF @@ROWCOUNT <> 0
		BEGIN
			SET @ResponseCode = '0000'

			COMMIT TRAN
		END
		ELSE
		BEGIN
			SET @ResponseCode = '9999'

			ROLLBACK TRAN
		END
	END
	ELSE
	BEGIN
		SET @ResponseCode = '9999'

		ROLLBACK TRAN
	END
END

