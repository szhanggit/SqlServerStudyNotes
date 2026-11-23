
-- =============================================
-- Author:		Knight YAO
-- Create date: 2014/05/08
-- Description:	Reverse Sogo Redemption Transaction.
-- =============================================
CREATE PROCEDURE [dbo].[spSGReverseRedemption] 
   @GAccount VARCHAR(50) = NULL
	,@PAccount VARCHAR(50) = NULL
	,@RequestId VARCHAR(50)
	,@OrgRequestId VARCHAR(50)
	,@ProgramId INT
	,@GAccountBalanceAvailable INT = NULL
	,@GAccountBalanceFrozen INT = NULL
	,@PAccountBalanceAvailable INT = NULL
	,@PAccountBalanceFrozen INT = NULL
	,@GAccountCheckSum VARCHAR(50) = NULL
	,@GAccountModifyVersion INT = NULL
	,@PAccountCheckSum VARCHAR(50) = NULL
	,@PAccountModifyVersion INT = NULL
	,@GTransactionCheckSum VARCHAR(50) = NULL
	,@PTransactionCheckSum VARCHAR(50) = NULL
	,@OrgGTransactionCheckSum VARCHAR(50) = NULL
	,@OrgPTransactionCheckSum VARCHAR(50) = NULL
	,@SecurityKeyId INT
	,@GAccountTranCode VARCHAR(50) = NULL
	,@PAccountTranCode VARCHAR(50) = NULL
	,@OrgGAccountTranCode VARCHAR(50) = NULL
	,@OrgPAccountTranCode VARCHAR(50) = NULL
	,@RefundedGAmount INT = NULL
	,@RefundedPAmount INT = NULL
	,@LastTranOn DATETIME
	,@ResponseCode VARCHAR(5) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
		IF ISNULL(@GAccount, '') = ''
			GOTO PAccount

		UPDATE [dbo].[Account]
		SET [BalanceAvailable] = @GAccountBalanceAvailable
			,[BalanceFrozen] = @GAccountBalanceFrozen
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

		UPDATE [dbo].[Transaction]
		SET [RefundedAmount] = @RefundedGAmount
			,[CheckSum] = @OrgGTransactionCheckSum
			,[Status] = 2
		WHERE [AccountNumber] = @GAccount
			AND [TranCode] = @OrgGAccountTranCode

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

		UPDATE [dbo].[Transaction]
		SET [RefundedAmount] = @RefundedPAmount
			,[CheckSum] = @OrgPTransactionCheckSum
			,[Status] = 2
		WHERE [AccountNumber] = @PAccount
			AND [TranCode] = @OrgPAccountTranCode

		IF @@ROWCOUNT <= 0
			GOTO E9999

		SGTran:

		UPDATE [dbo].[SGTransaction]
		SET [Status] = 2
		WHERE [TranCode] = @OrgRequestId

		IF @@ROWCOUNT <= 0
			GOTO E9999

		UPDATE [dbo].[SGTransaction]
		SET [ResponseCode] = '0000'
		WHERE [TranCode] = @RequestId

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
		SET [ResponseCode] = @ResponseCode
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
		WHERE [TranCode] = @RequestId
	END
END

