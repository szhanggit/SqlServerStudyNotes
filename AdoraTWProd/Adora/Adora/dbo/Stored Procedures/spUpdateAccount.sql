-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/05/04
-- Description:	spUpdateAccount.
-- =============================================
CREATE PROCEDURE spUpdateAccount
	@AccountNumber			varchar(50)
	,@ProgramId				int
	,@AccountCheckSum		varchar(50)
	,@ModifyVersion			int
	,@TransactionCheckSum	varchar(50)
	,@SecurityKeyId			int
	,@TranLocalDateTime		datetime
	,@TranLocalDate			int
	,@TranCode				varchar(50)
	,@Status				int
	,@LastTranOn			datetime
	,@ActiveFrom			datetime
	,@ActiveTo				datetime
	,@ResponseCode			varchar(5)	output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
    UPDATE [dbo].[Account]
	   SET [Checksum] = @AccountCheckSum
		  ,[TranCount] = [TranCount] + 1
		  ,[ModifyVersion] = [ModifyVersion] + 1
		  ,[Status] = @Status
		  ,[LastTranOn] = @LastTranOn
		  ,[ActiveFrom] = @ActiveFrom
		  ,[ActiveTo] = @ActiveTo
	 WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId

	 if @@ROWCOUNT <> 0
	 begin
		set @ResponseCode = '0000'

		UPDATE [dbo].[Transaction]
		   SET [TranLocalDate] = @TranLocalDate
			  ,[TranLocalDateTime] = @TranLocalDateTime
			  ,[ResponseCode] = @ResponseCode
			  ,[ModifyVersion] = @ModifyVersion + 1
			  ,[CheckSum] = @TransactionCheckSum
			  ,[SecurityKeyId] = @SecurityKeyId
		 WHERE [AccountNumber] = @AccountNumber and [TranCode] = @TranCode
	end
	else
	begin
		set @ResponseCode = '0018'

		UPDATE [dbo].[Transaction]
		   SET [TranLocalDate] = @TranLocalDate
			  ,[TranLocalDateTime] = @TranLocalDateTime
			  ,[ResponseCode] = @ResponseCode
			  ,[ModifyVersion] = @ModifyVersion
		 WHERE [AccountNumber] = @AccountNumber and [TranCode] = @TranCode
	end
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END
