
-- =============================================
-- Author:		Knight YAO
-- Create date: 2014/05/08
-- Description:	Send present for Sogo
-- =============================================
CREATE PROCEDURE [dbo].[spSendPresent] 
   @SourceGAccount VARCHAR(50) = NULL
	,@SourcePAccount VARCHAR(50) = NULL
	,@TargetGAccount VARCHAR(50) = NULL
	,@TargetPAccount VARCHAR(50) = NULL
	,@TargetMemberId INT
	,@SourceMemberId INT
	,@SourceMemberVersion INT
	,@SourceMemberMobile VARCHAR(30)
	,@SGTranCode VARCHAR(50)
	,@ProgramId INT
	,@SourceGAccountBalanceAvailable INT = NULL
	,@SourceGAccountBalanceFrozen INT = NULL
	,@SourcePAccountBalanceAvailable INT = NULL
	,@SourcePAccountBalanceFrozen INT = NULL
	,@TransferOutExpiryDate DATETIME
	,@SourceGAccountCheckSum VARCHAR(50) = NULL
	,@SourceGAccountModifyVersion INT = NULL
	,@SourcePAccountCheckSum VARCHAR(50) = NULL
	,@SourcePAccountModifyVersion INT = NULL
	,@GTransactionCheckSum VARCHAR(50) = NULL
	,@PTransactionCheckSum VARCHAR(50) = NULL
	,@SecurityKeyId INT
	,@TranLocalDateTime DATETIME
	,@TranLocalDate INT
	,@SourceGAccountTranCode VARCHAR(50) = NULL
	,@SourcePAccountTranCode VARCHAR(50) = NULL
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
		WHERE [Id] = @SourceMemberId
			AND [Version] = @SourceMemberVersion

		IF @@ROWCOUNT <= 0
			GOTO E0018

		IF ISNULL(@SourceGAccount, '') = ''
			GOTO PAccount

		UPDATE [dbo].[Account]
		SET [BalanceAvailable] = @SourceGAccountBalanceAvailable
			,[BalanceFrozen] = @SourceGAccountBalanceFrozen
			,[Checksum] = @SourceGAccountCheckSum
			,[ModifyVersion] = [ModifyVersion] + 1
			,[LastTranOn] = @LastTranOn
		WHERE [AccountNumber] = @SourceGAccount
			AND [ModifyVersion] = @SourceGAccountModifyVersion
			AND [ProgramId] = @ProgramId

		IF @@ROWCOUNT <= 0
			GOTO E0018

		INSERT INTO MemberVoucher (
			[MemberId]
			,[AccountNumber]
			,[ProgramId]
			,[AccountType]
			,[TransferOutTranCode]
			,[TransferOutExpiryDate]
			,[Status]
			,[GivenBy]
			)
		VALUES (
			@TargetMemberId
			,@SourceGAccount
			,@ProgramId
			,'G'
			,@SourceGAccountTranCode
			,@TransferOutExpiryDate
			,1
			,@SourceMemberMobile
			)

		IF @@ROWCOUNT <= 0
			GOTO E9999

		UPDATE [dbo].[Transaction]
		SET [TranLocalDate] = @TranLocalDate
			,[TranLocalDateTime] = @TranLocalDateTime
			,[ResponseCode] = '0000'
			,[ModifyVersion] = @SourceGAccountModifyVersion + 1
			,[BalanceAvailable] = @SourceGAccountBalanceAvailable
			,[BalanceFrozen] = @SourceGAccountBalanceFrozen
			,[CheckSum] = @GTransactionCheckSum
			,[SecurityKeyId] = @SecurityKeyId
		WHERE [AccountNumber] = @SourceGAccount
			AND [TranCode] = @SourceGAccountTranCode

		IF @@ROWCOUNT <= 0
			GOTO E9999

		PAccount:

		IF ISNULL(@SourcePAccount, '') = ''
			GOTO SGTran

		UPDATE [dbo].[Account]
		SET [BalanceAvailable] = @SourcePAccountBalanceAvailable
			,[BalanceFrozen] = @SourcePAccountBalanceFrozen
			,[Checksum] = @SourcePAccountCheckSum
			,[ModifyVersion] = [ModifyVersion] + 1
			,[LastTranOn] = @LastTranOn
		WHERE [AccountNumber] = @SourcePAccount
			AND [ModifyVersion] = @SourcePAccountModifyVersion
			AND [ProgramId] = @ProgramId

		IF @@ROWCOUNT <= 0
			GOTO E0018

		INSERT INTO MemberVoucher (
			[MemberId]
			,[AccountNumber]
			,[ProgramId]
			,[AccountType]
			,[TransferOutTranCode]
			,[TransferOutExpiryDate]
			,[Status]
			,[GivenBy]
			)
		VALUES (
			@TargetMemberId
			,@SourcePAccount
			,@ProgramId
			,'P'
			,@SourcePAccountTranCode
			,@TransferOutExpiryDate
			,1
			,@SourceMemberMobile
			)

		IF @@ROWCOUNT <= 0
			GOTO E9999

		UPDATE [dbo].[Transaction]
		SET [TranLocalDate] = @TranLocalDate
			,[TranLocalDateTime] = @TranLocalDateTime
			,[ResponseCode] = '0000'
			,[ModifyVersion] = @SourcePAccountModifyVersion + 1
			,[BalanceAvailable] = @SourcePAccountBalanceAvailable
			,[BalanceFrozen] = @SourcePAccountBalanceFrozen
			,[CheckSum] = @PTransactionCheckSum
			,[SecurityKeyId] = @SecurityKeyId
		WHERE [AccountNumber] = @SourcePAccount
			AND [TranCode] = @SourcePAccountTranCode

		IF @@ROWCOUNT <= 0
			GOTO E9999

		SGTran:

		UPDATE [dbo].[SGTransaction]
		SET [ServerTranDateTime] = @TranLocalDateTime
			,[TerminalTranDateTime] = @TranLocalDateTime
			,[ResponseCode] = '0000'
			,[ModifyVersion] = @SourceMemberVersion + 1
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

		IF ISNULL(@SourceGAccount, '') = ''
			GOTO PTranFail

		UPDATE [dbo].[Transaction]
		SET [TranLocalDate] = @TranLocalDate
			,[TranLocalDateTime] = @TranLocalDateTime
			,[ResponseCode] = @ResponseCode
			,[ModifyVersion] = @SourceGAccountModifyVersion
			,[BalanceAvailable] = @SourceGAccountBalanceAvailable
			,[BalanceFrozen] = @SourceGAccountBalanceFrozen
		WHERE [AccountNumber] = @SourceGAccount
			AND [TranCode] = @SourceGAccountTranCode

		PTranFail:

		IF ISNULL(@SourcePAccount, '') = ''
			GOTO SGTranFail

		UPDATE [dbo].[Transaction]
		SET [TranLocalDate] = @TranLocalDate
			,[TranLocalDateTime] = @TranLocalDateTime
			,[ResponseCode] = @ResponseCode
			,[ModifyVersion] = @SourcePAccountModifyVersion
			,[BalanceAvailable] = @SourcePAccountBalanceAvailable
			,[BalanceFrozen] = @SourcePAccountBalanceFrozen
		WHERE [AccountNumber] = @SourcePAccount
			AND [TranCode] = @SourcePAccountTranCode

		SGTranFail:

		UPDATE [dbo].[SGTransaction]
		SET [ServerTranDateTime] = @TranLocalDateTime
			,[TerminalTranDateTime] = @TranLocalDateTime
			,[ResponseCode] = @ResponseCode
		WHERE [TranCode] = @SGTranCode
	END
END

