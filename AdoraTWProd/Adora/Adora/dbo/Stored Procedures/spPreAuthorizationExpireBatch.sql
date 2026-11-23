-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/05/22
-- Description:	This is used to expire pre-authorization.
-- =============================================
CREATE PROCEDURE spPreAuthorizationExpireBatch
	@AccountNumber			varchar(50)
	,@ProgramCode			varchar(20)
	,@TranAmount			int
	,@TranCode				varchar(50)
	,@CurrentDateTime		datetime
	,@AccountChecksum		varchar(50)
	,@ModifyVersion			int
	,@ProgramId				int
	,@BalanceAvailable		int
	,@BalanceFrozen			int
	,@IsAccountHistory		bit
	,@IsTransactionHistory	bit
	,@TransactionChecksum	varchar(50)
	,@TranLocalDate			int
	,@TranLocalDateTime		datetime
	,@ErrorMessage			nvarchar(4000)	OUTPUT
	,@ErrorLine				int				OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @TransactionUpdateCount INT

	BEGIN TRAN

	BEGIN TRY
		if @IsTransactionHistory = 0
		begin
			UPDATE [dbo].[Transaction]
			SET [Status] = 2
				,[Checksum] = @TransactionChecksum
			WHERE [AccountNumber] = @AccountNumber AND [TranCode] = @TranCode
		end
		else
		begin
			UPDATE [dbo].[TransactionHistory]
			SET [Status] = 2
				,[Checksum] = @TransactionChecksum
			WHERE [AccountNumber] = @AccountNumber AND [TranCode] = @TranCode
		end

		if @@ROWCOUNT <> 0
		BEGIN
			if @IsAccountHistory = 0
			begin
				UPDATE [dbo].[Account]
				SET [LastTranOn] = @CurrentDateTime
					,[BalanceAvailable] = @BalanceAvailable
					,[BalanceFrozen] = @BalanceFrozen
					,[ModifyVersion] = [ModifyVersion] + 1
					,[Checksum] = @AccountChecksum
				WHERE [AccountNumber] = @AccountNumber AND [ProgramId] = @ProgramId AND [ModifyVersion] = @ModifyVersion
			end
			else
			begin
				UPDATE [dbo].[AccountHistory]
				SET [LastTranOn] = @CurrentDateTime
					,[BalanceAvailable] = @BalanceAvailable
					,[BalanceFrozen] = @BalanceFrozen
					,[ModifyVersion] = [ModifyVersion] + 1
					,[Checksum] = @AccountChecksum
				WHERE [AccountNumber] = @AccountNumber AND [ProgramId] = @ProgramId AND [ModifyVersion] = @ModifyVersion
			end
		END

		if @@ROWCOUNT <> 0
		BEGIN
			declare @HostSsn varchar(12)
			set @HostSsn = next value for HostSsn_Sequence
			set @HostSsn = right(replicate('0',9)+@HostSsn,9)
			INSERT INTO [dbo].[Transaction]
				([AccountNumber]
				,[ProgramCode]
				,[MerchantCode]
				,[TranUtcDate]
				,[HostSSN]
				,[TerminalSSN]
				,[TranUtcDateTimeL]
				,[TranUtcDateTime]
				,[TranType]
				,[TranAmount]
				,[TranCode]
				,[TranGUID]
				,[ModifyVersion]
				,[BalanceAvailable]
				,[BalanceFrozen]
				,[TranCodeRef]
				,[TranRealDateTime]
				,ResponseCode
				,[TranLocalDate]
				,[TranLocalDateTime])
			VALUES (
					@AccountNumber
					,@ProgramCode
					,'000000000000000'
					,cast(CONVERT(varchar(8) , @CurrentDateTime, 112) as int)
					,@HostSsn
					,@HostSsn
					,replace(replace(REPLACE(CONVERT(varchar(19) , @CurrentDateTime, 20),':',''),' ',''),'-','')
					,@currentDateTime
					,106
					,@TranAmount
					,@ProgramCode + '000000000000000' + CONVERT(varchar(8) , @CurrentDateTime, 112) + @HostSsn
					,NEWID()
					,@ModifyVersion + 1
					,@BalanceAvailable
					,@BalanceFrozen
					,@TranCode
					,@currentDateTime
					,'0000'
					,@TranLocalDate
					,@TranLocalDateTime
			)
		END
		ELSE
		BEGIN
			ROLLBACK TRAN;
		END
	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE()
		SELECT @ErrorLine = ERROR_LINE()

		IF @@TRANCOUNT > 0
			ROLLBACK TRAN;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRAN;
END
