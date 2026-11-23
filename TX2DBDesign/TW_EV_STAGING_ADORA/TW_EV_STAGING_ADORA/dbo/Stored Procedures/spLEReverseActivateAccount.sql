
CREATE PROCEDURE dbo.spLEReverseActivateAccount
@AccountNumber varchar(100),
@ProgramId int
AS
BEGIN
    SET NOCOUNT ON;
	
	if exists (select * from AccountLE with(nolock) where AccountNumber = @AccountNumber AND ProgramId = @ProgramId)
	begin
		update AccountLE 
		set FinanceExpireDate = null
		where AccountNumber = @AccountNumber AND ProgramId = @ProgramId;

		update top(1) les
		set les.TranCode = null, les.TransLEStatus = 0
		from AccountLE le with(nolock)
		inner join AccountLETrans les with(nolock) on le.Id = les.AccountLEId
		where les.TranType = 402 AND AccountNumber = @AccountNumber AND ProgramId = @ProgramId;

		delete from AccountLEBuffer where AccountNumber = @AccountNumber AND ProgramId = @ProgramId;
	end
END;
