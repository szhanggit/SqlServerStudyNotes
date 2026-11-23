CREATE PROCEDURE [dbo].[spClearStatistics]
	@BatchId				bigint
	,@ProgramCode			varchar(20)
	,@ErrorMessage			nvarchar(4000)	OUTPUT
	,@ErrorLine				int				OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN
	BEGIN TRY
		--DECLARE @CurrentDateTime DATETIME
		--DECLARE @CurrentDateTimeL BIGINT
		--DECLARE @YesterdayLocalDate INT
		--SET @CurrentDateTime = GETUTCDATE()
		--SET @CurrentDateTimeL= Cast(replace(replace(replace(convert(varchar(19),@CurrentDateTime,20),'-',''),' ',''),':','') as bigint)

		--SELECT @YesterdayLocalDate = [dbo].[fnCalcLocalDate](DATEADD(dd, -1, @CurrentDateTime), [TimeOffset]) From Program Where IdentityCode = @ProgramCode

		INSERT INTO [dbo].[BatchClearStatistics]
			([BatchId],[TranLocalDate],[ProgramCode],[ProductId],[MerchantId],[TranType],[TranCount],[TranAmount])
		SELECT @BatchId,[TranLocalDate],ProgramCode,ProductId,M.Id,[TranType],COUNT(TranCode) AS [TranCount],SUM([TranAmount]) AS TranAmount
		FROM (
			SELECT [TranLocalDate],t.[ProgramCode],ISNULL(A.ProductId, AH.ProductId) AS ProductId, [TranType],TranCode,CAST([TranAmount] AS bigint) as TranAmount,MerchantCode
			FROM [dbo].[Transaction] T
			inner join [dbo].[Program] P on P.IdentityCode = T.ProgramCode -- AND T.ProgramCode = @ProgramCode
			left join [dbo].[Account] A on T.AccountNumber = A.AccountNumber AND P.Id = A.ProgramId
			left join [dbo].[AccountHistory] AH on T.AccountNumber = AH.AccountNumber AND P.Id = AH.ProgramId
			INNER JOIN (SELECT ProgramCode, MAX(TranUtcDateTimeL) AS TranUtcDateTimeL FROM dbo.TransactionSyncCutLine GROUP BY ProgramCode) AS tcl 
				ON t.ProgramCode = tcl.ProgramCode AND t.TranUtcDateTimeL < tcl.TranUtcDateTimeL
			where T.ResponseCode='0000' and (A.ProductId is not null or AH.ProductId is not null)) AS S
		INNER JOIN [dbo].[Merchant] M ON S.MerchantCode = M.IdentityCode
		group by [TranLocalDate],[ProgramCode], ProductId, M.Id, [TranType]

		--SELECT 
        --   T.AccountNumber,T.ProgramCode,T.MerchantCode,HostSSN,TerminalSSN,T.[TranUtcDateTimeL],[TranUtcDateTime],T.TranLocalDate,TranLocalDateTime,TranTerminalDateTime,ShopCode
		--   ,TerminalCode,T.TranType,[Status],T.TranAmount,RefundedAmount,ResponseCode,1 AS [IsCleared],NodeNum,CallerIP,Channel,Parameters,T.TranCode,TranCodeRef,TranGUID,TranGUIDRef
		--   ,ModifyVersion,BalanceAvailable,BalanceFrozen,[Checksum],SecurityKeyId,Rsv1,Rsv2,Rsv3,[TranRealDateTime],[TranUtcDate],SettleDate
		--   ,BusinessDay,ShiftCode,MultiAccountsTransactionId
		--INTO #TransactionTemp
		--FROM [dbo].[Transaction] T
		--INNER JOIN  (SELECT ProgramCode, MAX(TranUtcDateTimeL) AS TranUtcDateTimeL FROM dbo.TransactionSyncCutLine GROUP BY ProgramCode) AS tcl 
		--	 ON t.ProgramCode = tcl.ProgramCode AND t.TranUtcDateTimeL < tcl.TranUtcDateTimeL
		----WHERE T.TranLocalDate=@YesterdayLocalDate AND T.ProgramCode = @ProgramCode

		--INSERT INTO [dbo].[TransactionHistory]
        --   ([AccountNumber],[ProgramCode],[MerchantCode],[HostSSN],[TerminalSSN],[TranUtcDateTimeL],[TranUtcDateTime],[TranLocalDate],[TranLocalDateTime],[TranTerminalDateTime]
		--   ,[ShopCode],[TerminalCode],[TranType],[Status],[TranAmount],[RefundedAmount],[ResponseCode],[IsCleared],[NodeNum],[CallerIP],[Channel],[Parameters],[TranCode],[TranCodeRef]
		--   ,[TranGUID],[TranGUIDRef],[ModifyVersion],[BalanceAvailable],[BalanceFrozen],[Checksum],[SecurityKeyId],[Rsv1],[Rsv2],[Rsv3],[TranRealDateTime],[TranUtcDate],SettleDate
		--   ,BusinessDay,ShiftCode,MultiAccountsTransactionId)
		--SELECT 
        --   [AccountNumber],[ProgramCode],[MerchantCode],[HostSSN],[TerminalSSN],[TranUtcDateTimeL],[TranUtcDateTime],[TranLocalDate],[TranLocalDateTime],[TranTerminalDateTime],[ShopCode]
        --   ,[TerminalCode],[TranType],[Status],[TranAmount],[RefundedAmount],[ResponseCode],[IsCleared],[NodeNum],[CallerIP],[Channel],[Parameters],[TranCode],[TranCodeRef],[TranGUID]
		--   ,[TranGUIDRef],[ModifyVersion],[BalanceAvailable],[BalanceFrozen],[Checksum],[SecurityKeyId],[Rsv1],[Rsv2],[Rsv3],[TranRealDateTime],[TranUtcDate],SettleDate
		--   ,BusinessDay,ShiftCode,MultiAccountsTransactionId
		--FROM #TransactionTemp

		--DELETE T
		--FROM [dbo].[Transaction] T
		--INNER JOIN #TransactionTemp TT ON T.TranCode = TT.TranCode AND T.AccountNumber = TT.AccountNumber

		--DROP TABLE #TransactionTemp
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