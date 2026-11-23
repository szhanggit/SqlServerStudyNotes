
CREATE PROC spQueryTransactionCount
    @ProgramCode varchar(50),
	@StartTranTime BIGINT,
	@EndTranTime BIGINT,
	@Count INT OUT
AS
BEGIN
    SET NOCOUNT ON;
    declare @result INT
	declare @resultHistory INT

	select @result = count(1) from [Transaction] with(nolock) where ProgramCode = @ProgramCode and TranUtcDateTimeL>=@StartTranTime and TranUtcDateTimeL<@EndTranTime

	select @resultHistory = count(1) from [TransactionHistory] with(nolock) where ProgramCode = @ProgramCode and TranUtcDateTimeL>=@StartTranTime and TranUtcDateTimeL<@EndTranTime

	Set @Count = @result+@resultHistory
END
