
CREATE PROCEDURE [dbo].[spMoveTransactionHistory]
	@RowCount			int	OUTPUT
	,@ErrorMessage			nvarchar(4000)	OUTPUT
	,@ErrorLine				int				OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRAN
	BEGIN TRY
SELECT ProgramCode, MAX(TranUtcDateTimeL) AS TranUtcDateTimeL 
INTO #SyncCutLine
FROM dbo.TransactionSyncCutLine GROUP BY ProgramCode

		SELECT top 3000
           T.AccountNumber,T.ProgramCode,T.MerchantCode,HostSSN,TerminalSSN,T.[TranUtcDateTimeL],[TranUtcDateTime],T.TranLocalDate,TranLocalDateTime,TranTerminalDateTime,ShopCode
		   ,TerminalCode,T.TranType,[Status],T.TranAmount,RefundedAmount,ResponseCode,1 AS [IsCleared],NodeNum,CallerIP,Channel,Parameters,T.TranCode,TranCodeRef,TranGUID,TranGUIDRef
		   ,ModifyVersion,BalanceAvailable,BalanceFrozen,[Checksum],SecurityKeyId,Rsv1,Rsv2,Rsv3,[TranRealDateTime],[TranUtcDate],SettleDate
		   ,BusinessDay,ShiftCode,MultiAccountsTransactionId
		INTO #TransactionTemp
		FROM [dbo].[Transaction] T
		INNER JOIN  #SyncCutLine AS tcl 
			 ON t.ProgramCode = tcl.ProgramCode AND t.TranUtcDateTimeL < tcl.TranUtcDateTimeL
			 order by t.TranUtcDateTimeL

		INSERT INTO [dbo].[TransactionHistory]
           ([AccountNumber],[ProgramCode],[MerchantCode],[HostSSN],[TerminalSSN],[TranUtcDateTimeL],[TranUtcDateTime],[TranLocalDate],[TranLocalDateTime],[TranTerminalDateTime]
		   ,[ShopCode],[TerminalCode],[TranType],[Status],[TranAmount],[RefundedAmount],[ResponseCode],[IsCleared],[NodeNum],[CallerIP],[Channel],[Parameters],[TranCode],[TranCodeRef]
		   ,[TranGUID],[TranGUIDRef],[ModifyVersion],[BalanceAvailable],[BalanceFrozen],[Checksum],[SecurityKeyId],[Rsv1],[Rsv2],[Rsv3],[TranRealDateTime],[TranUtcDate],SettleDate
		   ,BusinessDay,ShiftCode,MultiAccountsTransactionId)
		SELECT 
           [AccountNumber],[ProgramCode],[MerchantCode],[HostSSN],[TerminalSSN],[TranUtcDateTimeL],[TranUtcDateTime],[TranLocalDate],[TranLocalDateTime],[TranTerminalDateTime],[ShopCode]
           ,[TerminalCode],[TranType],[Status],[TranAmount],[RefundedAmount],[ResponseCode],[IsCleared],[NodeNum],[CallerIP],[Channel],[Parameters],[TranCode],[TranCodeRef],[TranGUID]
		   ,[TranGUIDRef],[ModifyVersion],[BalanceAvailable],[BalanceFrozen],[Checksum],[SecurityKeyId],[Rsv1],[Rsv2],[Rsv3],[TranRealDateTime],[TranUtcDate],SettleDate
		   ,BusinessDay,ShiftCode,MultiAccountsTransactionId
		FROM #TransactionTemp

		DELETE T
		FROM [dbo].[Transaction] T
		INNER JOIN #TransactionTemp TT ON T.TranCode = TT.TranCode AND T.AccountNumber = TT.AccountNumber

        SELECT @RowCount= Count(1) from #TransactionTemp

		DROP TABLE #TransactionTemp
		DROP TABLE #SyncCutLine
	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE()
		SELECT @ErrorLine = ERROR_LINE()

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END
