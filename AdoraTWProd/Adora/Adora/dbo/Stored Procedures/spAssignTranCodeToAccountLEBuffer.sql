
CREATE PROCEDURE dbo.spAssignTranCodeToAccountLEBuffer
@SessionId varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

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

	insert into AccountLETrans (AccountLEId, TranBalanceAvailable, TransLEStatus, TranType, TranCode, CeatedDate, TranAmount, MerchantCode, TranLocalDate)
	select le.Id, le.BalanceAvailable, 0, 402, leb.TranCode, GETDATE(), le.BalanceAvailable, leb.MerchantCode, leb.TranLocalDate from AccountLE le with(nolock)
	inner join AccountLETransBuffer leb with(nolock) on le.ProgramCode = leb.ProgramCode AND le.AccountNumber = leb.AccountNumber
	where le.AccountNumber in (select AccountNumber from AccountLETransBuffer where SessionId = @SessionId);

	delete from AccountLETransBuffer where SessionId = @SessionId;
END;

