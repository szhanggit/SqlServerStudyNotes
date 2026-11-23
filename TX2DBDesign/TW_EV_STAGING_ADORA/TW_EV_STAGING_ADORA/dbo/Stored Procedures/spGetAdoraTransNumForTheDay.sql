
CREATE PROCEDURE dbo.spGetAdoraTransNumForTheDay
@DateNum INT,
@TransNumber INT OUTPUT
AS
    SET NOCOUNT ON
	SELECT @TransNumber = COUNT(*) FROM (
	(SELECT * FROM [Transaction] WITH(NOLOCK) WHERE TranLocalDate = @DateNum AND ResponseCode != '0001' AND TranType != 504)
	union
	(SELECT * FROM [TransactionHistory] WITH(NOLOCK) WHERE TranLocalDate = @DateNum AND ResponseCode != '0001' AND TranType != 504)
	) t
