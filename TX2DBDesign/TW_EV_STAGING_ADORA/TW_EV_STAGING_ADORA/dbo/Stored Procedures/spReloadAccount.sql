-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/05/09
-- Description:	Reload account.
-- =============================================
CREATE PROCEDURE spReloadAccount
	@AccountNumber			varchar(50)
	,@ProgramId				int
	,@AccountCheckSum		varchar(50)
	,@ModifyVersion			int
	,@LastTranOn			datetime
	,@MerchantCode			varchar(50)
	,@SecurityKeyId			int
	,@TransactionChecksum	varchar(50)
	,@TranLocalDateTime		datetime
	,@TranLocalDate			int
	,@TranCode				varchar(50)
	,@BalanceAvailable		int
	,@BalanceFrozen			int
	,@IsSuccess				bit			output
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
		  ,[LastTranOn] = @LastTranOn
		  ,[BalanceAvailable] = @BalanceAvailable
	 WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId

	 if @@ROWCOUNT <> 0
	 begin
		UPDATE [dbo].[Transaction]
		   SET [TranLocalDate] = @TranLocalDate
			  ,[TranLocalDateTime] = @TranLocalDateTime
			  ,[ResponseCode] = '0000'
			  ,[ModifyVersion] = @ModifyVersion + 1
			  ,[BalanceAvailable] = @BalanceAvailable
			  ,[BalanceFrozen] = @BalanceFrozen
			  ,[CheckSum] = @TransactionCheckSum
			  ,[SecurityKeyId] = @SecurityKeyId
		 WHERE [AccountNumber] = @AccountNumber and [TranCode] = @TranCode
		set @IsSuccess = 1
	end
	else
	begin
		UPDATE [dbo].[Transaction]
		   SET [TranLocalDate] = @TranLocalDate
			  ,[TranLocalDateTime] = @TranLocalDateTime
			  ,[ResponseCode] = '0018'
			  ,[ModifyVersion] = @ModifyVersion
			  ,[BalanceAvailable] = @BalanceAvailable
			  ,[BalanceFrozen] = @BalanceFrozen
		 WHERE [AccountNumber] = @AccountNumber and [TranCode] = @TranCode
		set @IsSuccess = 0
	end

	END TRY
	BEGIN CATCH
		set @IsSuccess = 0
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END
