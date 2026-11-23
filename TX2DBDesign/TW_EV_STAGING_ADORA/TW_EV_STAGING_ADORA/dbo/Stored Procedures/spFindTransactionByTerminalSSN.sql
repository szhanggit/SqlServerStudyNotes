
CREATE PROCEDURE spFindTransactionByTerminalSSN 
	@AcountNumber				VARCHAR(50)
	,@TerminalSSN				VARCHAR(50)
	,@OriginalTransactionDate	INT
	,@isHistory					BIT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM dbo.[Transaction] WHERE [AccountNumber] = @AcountNumber AND TerminalSSN = @TerminalSSN AND TranUtcDate = @OriginalTransactionDate)
	BEGIN
		SET @isHistory = 0;
		SELECT [TranUtcDateTime],[TranType],[Status],[TranAmount],[TranCode],[TranCodeRef],[RefundedAmount],
			[ResponseCode],[ModifyVersion],[BalanceAvailable],[BalanceFrozen],[Checksum],[SecurityKeyId]
		FROM [dbo].[Transaction]
		WHERE [AccountNumber] = @AcountNumber AND TerminalSSN = @TerminalSSN AND TranUtcDate = @OriginalTransactionDate
	END
	ELSE
	BEGIN
		SET @isHistory = 1;
		SELECT [TranUtcDateTime],[TranType],[Status],[TranAmount],[TranCode],[TranCodeRef],[RefundedAmount],
			[ResponseCode],[ModifyVersion],[BalanceAvailable],[BalanceFrozen],[Checksum],[SecurityKeyId]
		FROM [dbo].[TransactionHistory]
		WHERE [AccountNumber] = @AcountNumber AND TerminalSSN = @TerminalSSN AND TranUtcDate = @OriginalTransactionDate
	END
END
