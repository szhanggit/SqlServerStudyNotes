CREATE PROCEDURE dbo.spAddClientCredit
@ClientId int,
@Amount DECIMAL(18,2),
@Source varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
	BEGIN TRAN
	insert into dbo.ClientCreditValue(Amount,ClientId,Source,CreatedOn,UpdatedOn,Status)
	values(@Amount,@ClientId,@Source,GETDATE(),GETDATE(),1)

		UPDATE cc SET cc.AvailableCredit = cc.AvailableCredit + @Amount, cc.ModifyVersion = cc.ModifyVersion + 1
			FROM dbo.ClientCredit cc
			Where cc.ClientId = @ClientId

	IF EXISTS(select 1 FROM dbo.Client c
			JOIN dbo.ClientCredit cc WITH(NOLOCK) ON cc.ClientId = c.Id
			WHERE cc.AvailableCredit <= 0 AND c.CanIssue = 1 and c.Id = @ClientId)
	BEGIN
		UPDATE c SET c.CanIssue = 0
			OUTPUT Deleted.Id, 'CreditLimitJob', 1, 'close CanIssue', GETDATE() INTO dbo.CreditActionHistory(ClientId,Operater,ActionType,[Description],CreateDate)
			FROM dbo.Client c
			JOIN dbo.ClientCredit cc WITH(NOLOCK) ON cc.ClientId = c.Id
			WHERE cc.AvailableCredit <= 0 AND c.CanIssue = 1 and c.Id = @ClientId
	END
		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		THROW;
	END CATCH
END