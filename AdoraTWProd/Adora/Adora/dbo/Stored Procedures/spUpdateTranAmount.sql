
CREATE PROCEDURE spUpdateTranAmount
	@AccountNumber	VARCHAR(50) 
	,@TranCode		VARCHAR(50)
	,@TranAmount	int
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE dbo.[Transaction] SET TranAmount = @TranAmount WHERE AccountNumber = @AccountNumber AND TranCode = @TranCode;
END
