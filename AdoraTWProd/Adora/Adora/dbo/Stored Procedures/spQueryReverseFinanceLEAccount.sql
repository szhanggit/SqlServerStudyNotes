
CREATE PROCEDURE dbo.spQueryReverseFinanceLEAccount
AS
BEGIN
    SET NOCOUNT ON;
	
	Declare @UpdatedAccountLE table ([Id] BIGINT, [SessionId] varchar(50), [AccountNumber] varchar(50), [ProgramCode] varchar(50), [ProgramId] INT, [BalanceAvailable] INT, InitBalance INT, LEInitBalance INT);
	DECLARE @SessionId VARCHAR(50) = CONVERT(VARCHAR(50),NEWID());
	DECLARE @StepLength INT = 3000;

	UPDATE TOP(@StepLength) le 
	SET le.SessionId = @SessionId OUTPUT Inserted.Id,Inserted.SessionId,Inserted.AccountNumber,Inserted.ProgramCode,Inserted.ProgramId,Inserted.BalanceAvailable,Inserted.InitBalance,Inserted.LEInitBalance
	into @UpdatedAccountLE
	from AccountLE le inner join AccountLETrans let on le.Id = let.AccountLEId
	AND let.TransLEStatus = 3;
	
	UPDATE AccountLETrans
	SET TransSessionId = @SessionId 
	where AccountLEId in (select Id from @UpdatedAccountLE) AND TransLEStatus = 3;
	
	select 
	le.Id as Id, 
	le.AccountNumber as AccountNumber,
	le.ProgramId as ProgramId, 
	le.ProgramCode as ProgramCode, 
	le.InitBalance as InitBalance,
	le.LEInitBalance as LEInitBalance,
	les.TranBalanceAvailable as BalanceAvailable,
	les.TranAmount as TranAmount, 
	le.SessionId as SessionId, 
	les.TranType as TranType,
	les.TranCode as TranCode,
	les.MerchantCode as MerchantCode,
	les.SettleDate as SettleDate,
	les.TranLocalDate as TranLocalDate
	from @UpdatedAccountLE le inner join AccountLETrans les with(nolock) on le.Id = les.AccountLEId
	where les.TransLEStatus = 3;
END;

