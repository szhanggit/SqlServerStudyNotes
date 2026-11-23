
-- =============================================
-- Author:		Knight YAO
-- Create date: 2014/05/08
-- Description:	Sogo Redemption Transaction.
-- =============================================
CREATE PROCEDURE [dbo].[spSGRedemption] 
   @GAccount VARCHAR(50) = null
	,@PAccount VARCHAR(50) = null
	,@MemberId INT
	,@MemberVersion INT
	,@SGTranCode VARCHAR(50)
	,@ProgramId INT
	,@GAccountBalanceAvailable INT = null
	,@GAccountBalanceFrozen INT = null
	,@PAccountBalanceAvailable INT = null
	,@PAccountBalanceFrozen INT = null
	,@GAccountCheckSum VARCHAR(50) = null
	,@GAccountModifyVersion INT = null
	,@PAccountCheckSum VARCHAR(50) = null
	,@PAccountModifyVersion INT = null
	,@GTransactionCheckSum VARCHAR(50) = null
	,@PTransactionCheckSum VARCHAR(50) = null
	,@SecurityKeyId INT
	,@GAccountTranCode VARCHAR(50) = null
	,@PAccountTranCode VARCHAR(50) = null
	,@LastTranOn DATETIME
	,@ResponseCode VARCHAR(5) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
		UPDATE [dbo].[Member]
		SET [PinCode] = 'EMPTYPIN'
			,[Version] = [Version] + 1
		WHERE [Id] = @MemberId
			AND [Version] = @MemberVersion

		IF @@ROWCOUNT <= 0
			GOTO E0018

		IF ISNULL(@GAccount, '') = ''
			GOTO PAccount

		UPDATE [dbo].[Account]
		SET [BalanceAvailable] = @GAccountBalanceAvailable
			,[Checksum] = @GAccountCheckSum
			,[ModifyVersion] = [ModifyVersion] + 1
			,[LastTranOn] = @LastTranOn
		WHERE [AccountNumber] = @GAccount
			AND [ModifyVersion] = @GAccountModifyVersion
			AND [ProgramId] = @ProgramId

		IF @@ROWCOUNT <= 0
			GOTO E0018

		UPDATE [dbo].[Transaction]
		SET [ResponseCode] = '0000'
			,[ModifyVersion] = @GAccountModifyVersion + 1
			,[BalanceAvailable] = @GAccountBalanceAvailable
			,[BalanceFrozen] = @GAccountBalanceFrozen
			,[CheckSum] = @GTransactionCheckSum
			,[SecurityKeyId] = @SecurityKeyId
		WHERE [AccountNumber] = @GAccount
			AND [TranCode] = @GAccountTranCode

		IF @@ROWCOUNT <= 0
			GOTO E9999

		PAccount:

		IF ISNULL(@PAccount, '') = ''
			GOTO SGTran

		UPDATE [dbo].[Account]
		SET [BalanceAvailable] = @PAccountBalanceAvailable
			,[BalanceFrozen] = @PAccountBalanceFrozen
			,[Checksum] = @PAccountCheckSum
			,[ModifyVersion] = [ModifyVersion] + 1
			,[LastTranOn] = @LastTranOn
		WHERE [AccountNumber] = @PAccount
			AND [ModifyVersion] = @PAccountModifyVersion
			AND [ProgramId] = @ProgramId

		IF @@ROWCOUNT <= 0
			GOTO E0018

		UPDATE [dbo].[Transaction]
		SET [ResponseCode] = '0000'
			,[ModifyVersion] = @PAccountModifyVersion + 1
			,[BalanceAvailable] = @PAccountBalanceAvailable
			,[BalanceFrozen] = @PAccountBalanceFrozen
			,[CheckSum] = @PTransactionCheckSum
			,[SecurityKeyId] = @SecurityKeyId
		WHERE [AccountNumber] = @PAccount
			AND [TranCode] = @PAccountTranCode

		IF @@ROWCOUNT <= 0
			GOTO E9999

		SGTran:

		UPDATE [dbo].[SGTransaction]
		SET  [ResponseCode] = '0000'
			,[ModifyVersion] = @MemberVersion + 1
		WHERE [TranCode] = @SGTranCode

		IF @@ROWCOUNT <= 0
			GOTO E9999

		SET @ResponseCode = '0000'

		GOTO TRYEND

		E0018:

		SET @ResponseCode = '0018'

		GOTO TRYEND

		E9999:

		SET @ResponseCode = '9999'

		GOTO TRYEND

		TRYEND:
	END TRY

	BEGIN CATCH
		SET @ResponseCode = '9999'
	END CATCH

	IF (@ResponseCode = '0000')
	BEGIN
		IF @@TRANCOUNT > 0
			COMMIT TRAN
	END
	ELSE
	BEGIN
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN

		IF ISNULL(@GAccount, '') = ''
			GOTO PTranFail

		UPDATE [dbo].[Transaction]
		SET  [ResponseCode] = @ResponseCode
			,[ModifyVersion] = @GAccountModifyVersion
			,[BalanceAvailable] = @GAccountBalanceAvailable
			,[BalanceFrozen] = @GAccountBalanceFrozen
		WHERE [AccountNumber] = @GAccount
			AND [TranCode] = @GAccountTranCode

		PTranFail:

		IF ISNULL(@PAccount, '') = ''
			GOTO SGTranFail

		UPDATE [dbo].[Transaction]
		SET [ResponseCode] = @ResponseCode
			,[ModifyVersion] = @PAccountModifyVersion
			,[BalanceAvailable] = @PAccountBalanceAvailable
			,[BalanceFrozen] = @PAccountBalanceFrozen
		WHERE [AccountNumber] = @PAccount
			AND [TranCode] = @PAccountTranCode

		SGTranFail:

		UPDATE [dbo].[SGTransaction]
		SET [ResponseCode] = @ResponseCode
		WHERE [TranCode] = @SGTranCode
	END
END

