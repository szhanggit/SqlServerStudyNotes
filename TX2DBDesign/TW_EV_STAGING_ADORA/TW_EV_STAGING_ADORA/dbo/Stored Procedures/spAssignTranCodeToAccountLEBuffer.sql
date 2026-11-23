
CREATE PROCEDURE spAssignTranCodeToAccountLEBuffer
@SessionId varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @MaxDay DateTime = '2899-01-01';
	update le
	set 
	le.TranCodeRef = t.TranCode,
	le.MerchantCode = t.MerchantCode,
	le.TranLocalDate = t.TranLocalDate
	from AccountLEBuffer le with(nolock) inner join (
	select p.Id as ProgramId, buf.AccountNumber as AccountNumber, buf.TranCode as TranCode, buf.SessionId as SessionId,
	buf.MerchantCode as MerchantCode, buf.TranLocalDate as TranLocalDate from AccountLETransBuffer buf with(nolock) 
	left join Program p with(nolock) on buf.ProgramCode = p.IdentityCode where buf.SessionId = @SessionId
	) t on le.ProgramId = t.ProgramId and le.AccountNumber = t.AccountNumber

	--Not the first time to activate accounts.
	update les		--Update the TranCode of AccountLETrans. The account is reactivated.
	set les.TranCode = leb.TranCode
	from AccountLE le with(nolock)
	inner join AccountLETransBuffer leb with(nolock) on le.ProgramCode = leb.ProgramCode AND le.AccountNumber = leb.AccountNumber
	left join AccountLETrans les on le.Id = les.AccountLEId AND les.TranType = 402
	where le.AccountNumber in (select AccountNumber from AccountLETransBuffer where SessionId = @SessionId) AND les.AccountLEId is not null;

	--It is the first time to activate accounts.
	insert into AccountLETrans (AccountLEId, TranBalanceAvailable, TransLEStatus, TranType, TranCode, CeatedDate, TranAmount, MerchantCode, TranLocalDate)
	select le.Id, le.BalanceAvailable, 0, 402, leb.TranCode, GETDATE(), le.BalanceAvailable, leb.MerchantCode, leb.TranLocalDate from AccountLE le with(nolock)
	inner join Account a with(nolock) on le.AccountNumber = a.AccountNumber AND le.ProgramId = a.ProgramId
	inner join AccountLETransBuffer leb with(nolock) on le.ProgramCode = leb.ProgramCode AND le.AccountNumber = leb.AccountNumber
	left join AccountLETrans les on le.Id = les.AccountLEId AND les.TranType = 402
	where le.AccountNumber in (select AccountNumber from AccountLETransBuffer where SessionId = @SessionId) AND les.AccountLEId is null
	AND ISNULL(a.ActiveTo, @MaxDay) >= @MaxDay;


	delete from AccountLETransBuffer where SessionId = @SessionId;
END
