
CREATE PROCEDURE spInsertAccountLE 
@AccountNumber varchar(50),
@ProgramId INT,
@ProgramCode VARCHAR(50),
@BalanceAvailable INT,
@FinanceExpireDays INT,
@FinanceExpireDate DATETIME
AS
BEGIN
	SET NOCOUNT ON;

	INSERT dbo.AccountLE
	(
	    ProgramId,
	    ProgramCode,
	    AccountNumber,
	    BalanceAvailable,
	    FinanceExpireDays,
	    FinanceExpireDate,
	    LEStatus
	)
	VALUES
	(   @ProgramId,
	    @ProgramCode,
	    @AccountNumber,
	    @BalanceAvailable,
	    @FinanceExpireDays,
	    @FinanceExpireDate,
	    1
	)
END
