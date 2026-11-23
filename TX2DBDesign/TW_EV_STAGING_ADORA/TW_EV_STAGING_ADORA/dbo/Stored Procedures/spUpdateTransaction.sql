-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/05/04
-- Description:	Update Transaction.
-- =============================================
CREATE PROCEDURE spUpdateTransaction
	@AccountNumber			varchar(50)
	,@BalanceAvailable		int
	,@BalanceFrozen			int
	,@ModifyVersion			int
	,@TransactionCheckSum	varchar(50)
	,@SecurityKeyId			int
	,@TranLocalDateTime		datetime
	,@TranLocalDate			int
	,@TranCode				varchar(50)
	,@ResponseCode			varchar(5)	output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	set @ResponseCode = '0000'

	UPDATE [dbo].[Transaction]
		SET [TranLocalDate] = @TranLocalDate
			,[TranLocalDateTime] = @TranLocalDateTime
			,[ResponseCode] = @ResponseCode
			,[ModifyVersion] = @ModifyVersion
			,[BalanceAvailable] = @BalanceAvailable
			,[BalanceFrozen] = @BalanceFrozen
			,[CheckSum] = @TransactionCheckSum
			,[SecurityKeyId] = @SecurityKeyId
		WHERE [AccountNumber] = @AccountNumber and [TranCode] = @TranCode
END
