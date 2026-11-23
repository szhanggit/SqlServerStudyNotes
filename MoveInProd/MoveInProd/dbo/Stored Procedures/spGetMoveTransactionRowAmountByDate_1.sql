
CREATE PROCEDURE spGetMoveTransactionRowAmountByDate 
	@DATETIMEINT BIGINT,
	@TransactionRowAmount INT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;
			
	SELECT @TransactionRowAmount = Count(1)
	FROM dbo.[Transaction] t1 WITH(NOLOCK)
	WHERE t1.TranLocalDate = @DATETIMEINT
		AND T1.ResponseCode = '0000'

END
