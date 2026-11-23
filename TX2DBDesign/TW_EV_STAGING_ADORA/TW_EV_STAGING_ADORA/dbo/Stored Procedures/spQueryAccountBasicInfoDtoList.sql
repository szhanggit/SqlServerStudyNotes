CREATE PROCEDURE [dbo].[spQueryAccountBasicInfoDtoList]
@InputTable AccountNumberProgramIdType READONLY
AS
	create table #TempTable
	(
		AccountNumber varchar(50) NOT NULL,
		ProgramId int NOT NULL,
		ProgramIdentityCode varchar(50) NOT NULL,
		[Status] int NOT NULL,
		BalanceAvailable int NOT NULL,
		ActiveTo datetime NOT NULL
	);
	DECLARE @count int;
	SET @count = (SELECT count(1) FROM @InputTable)

	INSERT INTO #TempTable SELECT a.AccountNumber, IT.ProgramId, p.IdentityCode as ProgramIdentityCode, a.[Status] , a.BalanceAvailable, a.ActiveTo FROM Account a INNER JOIN @InputTable IT ON a.AccountNumber = IT.AccountNumber AND a.ProgramId = IT.ProgramId 
	INNER JOIN Program p with(nolock) on IT.ProgramId = p.Id
	
	IF @@ROWCOUNT < @count 
	BEGIN
		INSERT INTO #TempTable SELECT ah.AccountNumber, ah.ProgramId, p.IdentityCode as ProgramIdentityCode, ah.[Status] , ah.BalanceAvailable, ah.ActiveTo FROM AccountHistory ah INNER JOIN 
		(
		SELECT AccountNumber,ProgramId FROM @InputTable
		EXCEPT
		SELECT AccountNumber,ProgramId FROM #TempTable
		) AS ht ON ah.AccountNumber = ht.AccountNumber AND ah.ProgramId = ht.ProgramId
		INNER JOIN Program p with(nolock) on ht.ProgramId = p.Id
	END

	SELECT AccountNumber, ProgramIdentityCode, [Status] , BalanceAvailable, ActiveTo FROM #TempTable