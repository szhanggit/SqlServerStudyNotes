
CREATE PROCEDURE dbo.spUpdateAccountLETransStatus
AS
BEGIN
	--LEStatus = 0 初始状态
	--LEStatus = 1 需要做LE交易的Account
	--LEStatus = 2 已经做了LE Transaction
	--LEStatus = 3 需要做reverse LE交易的Account
	--LEStatus = 4 已经做了reverse LE Transaction
	--LEStatus = 5 无需做LE交易(已经Redeem、Trash等)
	
    SET NOCOUNT ON;
	DECLARE @yesterday DATETIME = GETUTCDATE();
	DECLARE @MaxDay DateTime = '2899-01-01';

	BEGIN TRY
		BEGIN TRAN

		UPDATE let
		set let.TransLEStatus = 1, let.TranBalanceAvailable = le.BalanceAvailable, let.TranAmount = le.BalanceAvailable
		from AccountLE le inner join AccountLETrans let on le.Id = let.AccountLEId
		WHERE ISNULL(le.FinanceExpireDate, @MaxDay) <= @yesterday 
		AND let.TransLEStatus = 0;

		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		THROW;
	END CATCH
END;

