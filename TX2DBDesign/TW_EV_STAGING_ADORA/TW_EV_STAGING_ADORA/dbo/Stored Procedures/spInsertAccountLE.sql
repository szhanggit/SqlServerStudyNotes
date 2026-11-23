
CREATE PROCEDURE [dbo].[spInsertAccountLE]
@SessionId varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRAN
	BEGIN TRY
		
		insert into accountLE (ProgramId, ProgramCode, AccountNumber, 
		BalanceAvailable, FinanceExpireDays, FinanceExpireDate, 
		LEStatus, SessionId, LEInitBalance, InitBalance)
		select dup.ProgramId, dup.ProgramCode, dup.AccountNumber, 
		dup.BalanceAvailable, dup.FinanceExpireDays, dup.FinanceExpireDate, 
		dup.LEStatus, dup.SessionId, dup.LEInitBalance, dup.InitBalance from AccountLEBufferDup dup with(nolock)
		left join accountLE le with(nolock) on le.AccountNumber = dup.AccountNumber and le.ProgramId = dup.ProgramId
		where le.AccountNumber is null AND dup.SessionId = @SessionId;

		delete from AccountLEBufferDup where SessionId = @SessionId;			

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;
	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END;
