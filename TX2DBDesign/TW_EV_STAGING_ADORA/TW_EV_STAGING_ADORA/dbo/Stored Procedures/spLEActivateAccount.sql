
CREATE PROCEDURE dbo.spLEActivateAccount
@AccountNumber varchar(100),
@ProgramId int,
@TranCode varchar(100)
AS
BEGIN
    SET NOCOUNT ON;

	declare @BalanceAvailable int;
	declare @AccountLEId int;
	select @BalanceAvailable = BalanceAvailable from Account with(nolock) where AccountNumber = @AccountNumber AND ProgramId = @ProgramId;
	select @AccountLEId = Id from AccountLE with(nolock) where AccountNumber = @AccountNumber AND ProgramId = @ProgramId;

	if not exists (select * from AccountLEBuffer with(nolock) where AccountNumber = @AccountNumber AND ProgramId = @ProgramId)
	begin
		insert into AccountLEBuffer (AccountNumber, ProgramId, BalanceAvailable, ActivatedOn, TranType, TranCodeRef, TranLocalDate)
		values (@AccountNumber, @ProgramId, @BalanceAvailable, GETDATE(), 402, @TranCode, Year(GETDATE())*10000 + Month(GETDATE())*100 + Day(GETDATE()));
	end

	if not exists (select les.* from AccountLE le with(nolock)
	inner join AccountLETrans les with(nolock) on le.Id = les.AccountLEId
	where les.TranType = 402 AND AccountNumber = @AccountNumber AND ProgramId = @ProgramId)
	begin
		insert into AccountLETrans (AccountLEId, TranBalanceAvailable, TranAmount, TransLEStatus, TranType, TranCode, TranLocalDate, CeatedDate)
		values (@AccountLEId, @BalanceAvailable, @BalanceAvailable, 0, 402, @TranCode, Year(GETDATE())*10000 + Month(GETDATE())*100 + Day(GETDATE()), Getdate());
	end
	else
	begin
		update les
		set les.TranCode = @TranCode
		from AccountLE le
		inner join AccountLETrans les with(nolock) on le.Id = les.AccountLEId
		where les.TranType = 402 AND AccountNumber = @AccountNumber AND ProgramId = @ProgramId
	end

END;
