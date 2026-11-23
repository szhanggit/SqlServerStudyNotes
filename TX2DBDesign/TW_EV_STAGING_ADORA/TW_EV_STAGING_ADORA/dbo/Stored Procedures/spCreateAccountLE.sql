
CREATE PROCEDURE dbo.spCreateAccountLE
@ProgramId int,
@ProgramCode varchar(50),
@AccountNumber varchar(50),
@BalanceAvailable int,
@FinanceExpireDays int,
@SessionId varchar(50)
AS
BEGIN
		insert accountLE (ProgramId, ProgramCode, AccountNumber, 
		BalanceAvailable, FinanceExpireDays, FinanceExpireDate, 
		LEStatus, SessionId, LEInitBalance, InitBalance)
        VALUES(@ProgramId,@ProgramCode,@AccountNumber,
        @BalanceAvailable,@FinanceExpireDays,null,
        5,@SessionId,@BalanceAvailable,@BalanceAvailable)
END;
