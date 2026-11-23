CREATE PROCEDURE spUpdateTransactionHistory
	@AccountNumber			varchar(50)
	,@TranCode				varchar(50)
	,@Status				tinyint
	,@TransactionCheckSum	varchar(50) = null
	,@ResponseCode			varchar(5)	output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	set @ResponseCode = '0000'

	UPDATE [dbo].[TransactionHistory]
		SET [Status] = @Status
			,[CheckSum] = @TransactionCheckSum
		WHERE [AccountNumber] = @AccountNumber and [TranCode] = @TranCode
END