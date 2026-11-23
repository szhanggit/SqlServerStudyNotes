-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/04/28
-- Description:	Reverse pre-authorization.
-- =============================================
CREATE PROCEDURE spReversePreAuthorization
	@AccountNumber					varchar(50)
	,@ProgramId						int
	,@BalanceAvailable				int
	,@BalanceFrozen					int
	,@AccountCheckSum				varchar(50)
	,@ModifyVersion					int
	,@TransactionCheckSum			varchar(50)
	,@SecurityKeyId					int
	,@TranLocalDateTime				datetime
	,@TranLocalDate					int
	,@TranCode						varchar(50)
	,@IsAccountHistory				bit
	,@IsReversedTransactionHistory	bit
	,@ReversedTranCode				varchar(50)
	,@LastTranOn					datetime
	,@TranCodeRef					varchar(50)
	,@ReversedTransactionChecksum	varchar(50)
	,@ResponseCode					varchar(5)	output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
	if (@IsAccountHistory = 0)
	begin
		UPDATE [dbo].[Account]
			SET [BalanceAvailable] = @BalanceAvailable
				,[BalanceFrozen] = @BalanceFrozen
				,[Checksum] = @AccountCheckSum
				,[ModifyVersion] = [ModifyVersion] + 1
				,[LastTranOn] = @LastTranOn
			WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId
	end
	else
	begin
		UPDATE [dbo].[AccountHistory]
			SET [BalanceAvailable] = @BalanceAvailable
				,[BalanceFrozen] = @BalanceFrozen
				,[Checksum] = @AccountCheckSum
				,[ModifyVersion] = [ModifyVersion] + 1
				,[LastTranOn] = @LastTranOn
			WHERE [AccountNumber] = @AccountNumber and [ModifyVersion] = @ModifyVersion and [ProgramId] = @ProgramId
	end

	 if @@ROWCOUNT <> 0
	 begin
		set @ResponseCode = '0000'

		UPDATE [dbo].[Transaction]
			SET [TranLocalDate] = @TranLocalDate
				,[TranLocalDateTime] = @TranLocalDateTime
				,[ResponseCode] = @ResponseCode
				,[ModifyVersion] = @ModifyVersion + 1
				,[BalanceAvailable] = @BalanceAvailable
				,[BalanceFrozen] = @BalanceFrozen
				,[CheckSum] = @TransactionCheckSum
				,[SecurityKeyId] = @SecurityKeyId
			WHERE [AccountNumber] = @AccountNumber and [TranCode] = @TranCode

		if @IsReversedTransactionHistory > 0
		begin
			UPDATE [dbo].[TransactionHistory]
			   SET [Status] = 2
					,[CheckSum] = @ReversedTransactionChecksum
			 WHERE [AccountNumber] = @AccountNumber AND [TranCode] = @TranCodeRef
		end
		else
		begin
			UPDATE [dbo].[Transaction]
			   SET [Status] = 2
					,[CheckSum] = @ReversedTransactionChecksum
			 WHERE [AccountNumber] = @AccountNumber AND [TranCode] = @TranCodeRef
		end
	end
	else
	begin
		set @ResponseCode = '0018'

		UPDATE [dbo].[Transaction]
		   SET [TranLocalDate] = @TranLocalDate
			  ,[TranLocalDateTime] = @TranLocalDateTime
			  ,[ResponseCode] = @ResponseCode
			  ,[ModifyVersion] = @ModifyVersion
			  ,[BalanceAvailable] = @BalanceAvailable
			  ,[BalanceFrozen] = @BalanceFrozen
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
