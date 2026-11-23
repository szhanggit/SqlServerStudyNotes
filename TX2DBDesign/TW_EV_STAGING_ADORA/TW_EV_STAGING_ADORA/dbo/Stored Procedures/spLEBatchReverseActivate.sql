
CREATE PROCEDURE dbo.spLEBatchReverseActivate
@InputTable AccountNumberProgramIdType READONLY
AS

	UPDATE al SET al.FinanceExpireDate = null  from dbo.AccountLE al with(NOLOCK) INNER JOIN @InputTable IT ON al.AccountNumber = IT.AccountNumber AND al.ProgramId = IT.ProgramId

	update les
	set les.TranCode = null, les.TransLEStatus = 0
	from AccountLE le with(nolock)
	inner join AccountLETrans les with(nolock) on le.Id = les.AccountLEId
	INNER JOIN @InputTable IT ON le.AccountNumber = IT.AccountNumber AND le.ProgramId = IT.ProgramId
	where les.TranType = 402;

	delete from AccountLEBuffer FROM AccountLEBuffer alb INNER JOIN @InputTable IT ON alb.AccountNumber = IT.AccountNumber AND alb.ProgramId = IT.ProgramId;
