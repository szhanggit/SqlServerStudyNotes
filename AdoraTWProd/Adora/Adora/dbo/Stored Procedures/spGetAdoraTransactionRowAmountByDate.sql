

CREATE PROCEDURE [dbo].[spGetAdoraTransactionRowAmountByDate] 
	@DATETIMEINT BIGINT,
	@TransactionRowAmount INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
		
	DECLARE @TransactionAmount INT;
	DECLARE @TransactionHistoryAmount INT;

	SET @TransactionAmount = 0
	SET @TransactionHistoryAmount = 0

	SELECT @TransactionAmount = Count(1)
	FROM dbo.[Transaction] t1 WITH(NOLOCK)
	WHERE t1.TranLocalDate = @DATETIMEINT
		AND T1.ResponseCode = '0000'
		AND T1.TranType != 504

	SELECT @TransactionHistoryAmount = Count(1)
	FROM dbo.[TransactionHistory] t1 WITH(NOLOCK)
	WHERE t1.TranLocalDate = @DATETIMEINT
		AND T1.ResponseCode = '0000'
		AND T1.TranType != 504

	SELECT @TransactionRowAmount = @TransactionAmount + @TransactionHistoryAmount;
END
