
CREATE PROCEDURE [dbo].[spClearTransactionTemp]
	@BatchId BIGINT = 0
AS
BEGIN
	SET NOCOUNT ON;
	DELETE TransactionTemp
	where  BatchId <=@BatchId

END

