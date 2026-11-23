
CREATE PROCEDURE spUpdateReverseFinanceLEAccount
AS
BEGIN
    SET NOCOUNT ON;
	
	--根据buf表

	DECLARE @SessionId VARCHAR(50) = CONVERT(VARCHAR(50),NEWID());
	DECLARE @StepLength INT = 1000;

	WHILE EXISTS(SELECT 1 FROM dbo.AccountLEBuffer)
	BEGIN
		BEGIN TRY
			BEGIN TRAN
			UPDATE TOP(@StepLength) dbo.AccountLEBuffer SET SessionId = @SessionId;
			UPDATE LE SET LE.LEStatus = (CASE LE.LEStatus WHEN 0 THEN 1 WHEN 2 THEN 3 ELSE LE.LEStatus END),LE.BalanceAvailable = buf.BalanceAvailable
				FROM dbo.AccountLE LE JOIN dbo.AccountLEBuffer buf ON  buf.AccountNumber = LE.AccountNumber AND buf.ProgramCode = LE.ProgramCode
				WHERE buf.SessionId = @SessionId;
			DELETE dbo.AccountLEBuffer WHERE SessionId = @SessionId;
			COMMIT;
		END TRY
		BEGIN CATCH
			ROLLBACK;
			THROW;
		END CATCH
	END
END;