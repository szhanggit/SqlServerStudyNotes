-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/5/28
-- Description:	Find Transactions
-- =============================================
CREATE PROCEDURE spFindTransactionHistory
	-- Add the parameters for the stored procedure here
	@AcountNumber		varchar(50)
	,@TranCode			varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [TranUtcDateTime],[TranType],[Status],[TranAmount],[TranCodeRef],[RefundedAmount],[ResponseCode],[ModifyVersion],[BalanceAvailable],[BalanceFrozen],[Checksum],[SecurityKeyId]
	FROM [dbo].[TransactionHistory]
	WHERE [AccountNumber] = @AcountNumber AND [TranCode] = @TranCode
END
