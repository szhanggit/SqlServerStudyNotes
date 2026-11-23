
CREATE PROCEDURE spUpdateFinanceExpireDate
AS
BEGIN
    SET NOCOUNT ON;

	--LEStatus = 0 需要做LE交易的Account(初始状态)
	--LEStatus = 1 不需要做LE交易的Account
	--LEStatus = 2 已经做了LE Transaction
	--LEStatus = 3 需要做reverse LE交易的Account
	--LEStatus = 4 已经做了reverse LE Transaction

	DECLARE @SessionId VARCHAR(50) = CONVERT(VARCHAR(50),NEWID());
	DECLARE @yesterday DATE = DATEADD(DAY,-1,GETDATE());
	DECLARE @stepLength INT = 1000;--步长
	DECLARE @effectCount INT = @stepLength;

	WHILE @effectCount >= @stepLength
	BEGIN
		UPDATE TOP(@stepLength) LE SET LE.FinanceExpireDate = DATEADD(DAY,LE.FinanceExpireDays,a.ActivatedOn),LE.SessionId = @SessionId FROM
			dbo.AccountLE LE JOIN dbo.Account a WITH(NOLOCK) ON a.AccountNumber = LE.AccountNumber AND a.ProgramId = LE.ProgramId
			 WHERE LE.FinanceExpireDate <= @yesterday AND LE.LEStatus = 0 AND LE.SessionId <> @SessionId AND LE.FinanceExpireDate <> CONVERT(DATE,DATEADD(DAY,LE.FinanceExpireDays,a.ActivatedOn))

		SET @effectCount = @@ROWCOUNT;
	END

	SET @effectCount = @stepLength
	WHILE @effectCount >= @stepLength
	BEGIN
		UPDATE TOP(@stepLength) LE SET LE.LEStatus = 1
			FROM dbo.AccountLE LE JOIN dbo.Account a WITH(NOLOCK) ON a.AccountNumber = LE.AccountNumber AND a.ProgramId = LE.ProgramId
			 WHERE LE.FinanceExpireDate <= @yesterday AND LE.LEStatus = 0 AND a.Status <> 2

		SET @effectCount = @@ROWCOUNT;
	END
END;