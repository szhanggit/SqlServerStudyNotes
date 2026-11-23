
-- =============================================
-- Author:		Knight YAO
-- Create date: 2014/05/08
-- Description:	Do transfer transaction for an account
-- =============================================
CREATE PROCEDURE [dbo].[spTransferAccount] 
   @SourceAccount VARCHAR(50)
	,@TargetAccount VARCHAR(50)
	,@ProgramId INT
	,@SourceAccountBalanceAvailable INT
	,@TargetAccountBalanceAvailable INT
	,@SourceAccountBalanceFrozen INT
	,@TargetAccountBalanceFrozen INT
	,@SourceAccountStatus INT
	,@TargetAccountStatus INT
	,@SourceAccountCheckSum VARCHAR(50)
	,@TargetAccountCheckSum VARCHAR(50)
	,@SourceAccountModifyVersion INT
	,@TargetAccountModifyVersion INT
	,@TransactionFromCheckSum VARCHAR(50)
	,@TransactionToCheckSum VARCHAR(50)
	,@SecurityKeyId INT
	,@TranLocalDateTime DATETIME
	,@TranLocalDate INT
	,@SourceAccountTranCode VARCHAR(50)
	,@TargetAccountTranCode VARCHAR(50)
	,@LastTranOn DATETIME
	,@ResponseCode VARCHAR(5) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
		UPDATE [dbo].[Account]
		SET [BalanceAvailable] = @TargetAccountBalanceAvailable
			,[BalanceFrozen] = @TargetAccountBalanceFrozen
			,[Checksum] = @TargetAccountCheckSum
			,[Status] = @TargetAccountStatus
			,[ModifyVersion] = [ModifyVersion] + 1
			,[LastTranOn] = @LastTranOn
		WHERE [AccountNumber] = @TargetAccount
			AND [ModifyVersion] = @TargetAccountModifyVersion
			AND [ProgramId] = @ProgramId

		IF (@@ROWCOUNT <= 0)
			GOTO E0018

		UPDATE [dbo].[Account]
		SET [BalanceAvailable] = @SourceAccountBalanceAvailable
			,[BalanceFrozen] = @SourceAccountBalanceFrozen
			,[Checksum] = @SourceAccountCheckSum
			,[Status] = @SourceAccountStatus
			,[ModifyVersion] = [ModifyVersion] + 1
			,[LastTranOn] = @LastTranOn
		WHERE [AccountNumber] = @SourceAccount
			AND [ModifyVersion] = @SourceAccountModifyVersion
			AND [ProgramId] = @ProgramId

		IF (@@ROWCOUNT <= 0)
			GOTO E0018

		UPDATE [dbo].[MemberVoucher]
		SET [Status] = 2
		WHERE [AccountNumber] = @SourceAccount
			AND [ProgramId] = @ProgramId

		IF (@@ROWCOUNT <= 0)
			GOTO E0018

		UPDATE [dbo].[Transaction]
		SET [TranLocalDate] = @TranLocalDate
			,[TranLocalDateTime] = @TranLocalDateTime
			,[ResponseCode] = '0000'
			,[ModifyVersion] = @TargetAccountModifyVersion + 1
			,[BalanceAvailable] = @TargetAccountBalanceAvailable
			,[BalanceFrozen] = @TargetAccountBalanceFrozen
			,[CheckSum] = @TransactionToCheckSum
			,[SecurityKeyId] = @SecurityKeyId
		WHERE [AccountNumber] = @TargetAccount
			AND [TranCode] = @TargetAccountTranCode

		IF (@@ROWCOUNT <= 0)
			GOTO E9999

		UPDATE [dbo].[Transaction]
		SET [TranLocalDate] = @TranLocalDate
			,[TranLocalDateTime] = @TranLocalDateTime
			,[ResponseCode] = '0000'
			,[ModifyVersion] = @SourceAccountModifyVersion + 1
			,[BalanceAvailable] = @SourceAccountBalanceAvailable
			,[BalanceFrozen] = @SourceAccountBalanceFrozen
			,[CheckSum] = @TransactionFromCheckSum
			,[SecurityKeyId] = @SecurityKeyId
		WHERE [AccountNumber] = @SourceAccount
			AND [TranCode] = @SourceAccountTranCode

		IF (@@ROWCOUNT <= 0)
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
	END CATCH;

	IF (@ResponseCode = '0000')
	BEGIN
		IF @@TRANCOUNT > 0
			COMMIT TRAN
	END
	ELSE
	BEGIN
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN

		UPDATE [dbo].[Transaction]
		SET [TranLocalDate] = @TranLocalDate
			,[TranLocalDateTime] = @TranLocalDateTime
			,[ResponseCode] = @ResponseCode
			,[ModifyVersion] = @TargetAccountModifyVersion
			,[BalanceAvailable] = @TargetAccountBalanceAvailable
			,[BalanceFrozen] = @TargetAccountBalanceFrozen
		WHERE [AccountNumber] = @TargetAccount
			AND [TranCode] = @TargetAccountTranCode

		UPDATE [dbo].[Transaction]
		SET [TranLocalDate] = @TranLocalDate
			,[TranLocalDateTime] = @TranLocalDateTime
			,[ResponseCode] = @ResponseCode
			,[ModifyVersion] = @SourceAccountModifyVersion
			,[BalanceAvailable] = @SourceAccountBalanceAvailable
			,[BalanceFrozen] = @SourceAccountBalanceFrozen
		WHERE [AccountNumber] = @SourceAccount
			AND [TranCode] = @SourceAccountTranCode
	END
END

