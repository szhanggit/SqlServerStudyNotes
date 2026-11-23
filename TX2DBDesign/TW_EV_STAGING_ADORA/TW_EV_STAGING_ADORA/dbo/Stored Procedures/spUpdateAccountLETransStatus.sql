
CREATE PROCEDURE dbo.spUpdateAccountLETransStatus
AS
BEGIN
	--LEStatus = 0 åˆå§‹çŠ¶æ€
	--LEStatus = 1 éœ€è¦åšLEäº¤æ˜“çš„Account
	--LEStatus = 2 å·²ç»åšäº†LE Transaction
	--LEStatus = 3 éœ€è¦åšreverse LEäº¤æ˜“çš„Account
	--LEStatus = 4 å·²ç»åšäº†reverse LE Transaction
	--LEStatus = 5 æ— éœ€åšLEäº¤æ˜“(å·²ç»Redeemã€Trashç­‰)
	
    SET NOCOUNT ON;
	DECLARE @yesterday DATETIME = GETUTCDATE();
	DECLARE @MaxDay DateTime = '2899-01-01';

	BEGIN TRY
		BEGIN TRAN

		UPDATE le
		SET le.LEInitBalance = temp.BalanceAvailable, le.BalanceAvailable = temp.BalanceAvailable
		from AccountLE le with(nolock)
		inner join (select le.Id, a.BalanceAvailable
from AccountLE le with(nolock)
inner join AccountLETrans let with(nolock) on le.Id = let.AccountLEId
inner join Account a with(nolock) on a.AccountNumber = le.AccountNumber AND a.ProgramId = le.ProgramId
WHERE ISNULL(le.FinanceExpireDate, @MaxDay) > @yesterday and (le.LEInitBalance <> a.BalanceAvailable or le.BalanceAvailable <> a.BalanceAvailable)
AND let.TransLEStatus = 0 and let.CeatedDate>DATEADD(HOUR,-12,GETUTCDATE())) as temp on le.Id = temp.Id

		UPDATE let
		set let.TransLEStatus = 1, let.TranBalanceAvailable = temp.BalanceAvailable, let.TranAmount = temp.BalanceAvailable
		from AccountLETrans let with(nolock) 
		inner join (select let.AId,le.BalanceAvailable
from AccountLE le with(nolock) 
inner join AccountLETrans let with(nolock) on le.Id = let.AccountLEId
WHERE ISNULL(le.FinanceExpireDate, @MaxDay) <= @yesterday 
AND let.TransLEStatus = 0) as temp on temp.AId = let.AId

		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		THROW;
	END CATCH
END;
