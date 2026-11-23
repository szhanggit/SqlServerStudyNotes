
CREATE PROCEDURE [dbo].[spUpdateLEFromBuffer]
AS
BEGIN
	--LEStatus = 0 初始状态
	--LEStatus = 1 需要做LE交易的Account
	--LEStatus = 2 已经做了LE Transaction
	--LEStatus = 3 需要做reverse LE交易的Account
	--LEStatus = 4 已经做了reverse LE Transaction
	--LEStatus = 5 无需做LE交易(已经Redeem、Trash等)
	
    SET NOCOUNT ON;
	
	DECLARE @SessionId VARCHAR(50) = CONVERT(VARCHAR(50),NEWID());
	DECLARE @StepLength INT = 3000;
	DECLARE @yesterday DATETIME = GETUTCDATE();
	--DECLARE @yesterday DATETIME = DATEADD(Day, 10, GETUTCDATE());
	DECLARE @MaxDay DateTime = '2899-01-01';

	WHILE (@StepLength >= 3000)
	BEGIN
		BEGIN TRY
			BEGIN TRAN

			UPDATE TOP(@StepLength) dbo.AccountLEBuffer 
			SET SessionId = @SessionId;

			UPDATE LE 
			SET 
				LE.BalanceAvailable = buf.BalanceAvailable,
				LE.FinanceExpireDate = DATEADD(DAY,LE.FinanceExpireDays,CONVERT(NVARCHAR(10), buf.ActivatedOn, 120) + ' 15:59:59.000')
			FROM dbo.AccountLE LE JOIN dbo.AccountLEBuffer buf ON  buf.AccountNumber = LE.AccountNumber AND buf.ProgramId = LE.ProgramId
			WHERE buf.SessionId = @SessionId;

			DELETE dbo.AccountLEBuffer WHERE SessionId = @SessionId;

			SET @StepLength = @@ROWCOUNT;
			COMMIT;
		END TRY
		BEGIN CATCH
			ROLLBACK;
			THROW;
		END CATCH
	END
END;

