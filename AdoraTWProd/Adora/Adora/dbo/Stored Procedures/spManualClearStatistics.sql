
CREATE PROCEDURE [dbo].[spManualClearStatistics]
	 @ProgramCode			varchar(20)
	,@DateTime				DATETIME
	,@ErrorMessage			nvarchar(4000)	OUTPUT
	,@ErrorLine				int				OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON; 

	BEGIN TRAN
	BEGIN TRY

		DECLARE @YesterdayLocalDate INT
		DECLARE @BatchId BIGINT

		SELECT @YesterdayLocalDate = [dbo].[fnCalcLocalDate](DATEADD(dd, -1, @DateTime), [TimeOffset])
		FROM Program 
		WHERE IdentityCode = @ProgramCode

		
		INSERT INTO dbo.Batch
		        ( Year ,
		          Month ,
		          Day ,
		          StartTime ,
		          EndTime ,
		          BatchType ,
		          Status
		        )
		VALUES  ( YEAR(@DateTime),
		          MONTH(@DateTime) ,
		          DAY(@DateTime) , 
		          GETDATE(), 
		          NULL,
		          2, 
		          1 
		        )
        SELECT @BatchId = SCOPE_IDENTITY()

		INSERT INTO [dbo].[BatchClearStatistics]
			([BatchId]
			,[TranLocalDate]
			,[ProgramCode]
			,[ProductId]
			,[MerchantId]
			,[TranType]
			,[TranCount]
			,[TranAmount])
		SELECT @BatchId
			,[TranLocalDate]
			,@ProgramCode
			,ProductId
			,M.Id
			,[TranType]
			,COUNT(TranCode) AS [TranCount]
			,SUM([TranAmount]) AS TranAmount
		FROM (
			SELECT [TranLocalDate]
				,[ProgramCode]
				,ISNULL(A.ProductId, AH.ProductId) AS ProductId
				,[TranType]
				,TranCode
				,[TranAmount]
				,MerchantCode
			FROM [dbo].[Transaction] T
				INNER JOIN [dbo].[Program] P on P.IdentityCode = T.ProgramCode AND T.ProgramCode = @ProgramCode
				LEFT JOIN [dbo].[Account] A on T.AccountNumber = A.AccountNumber AND P.Id = A.ProgramId
				LEFT JOIN [dbo].[AccountHistory] AH on T.AccountNumber = AH.AccountNumber AND P.Id = AH.ProgramId
			WHERE T.TranLocalDate <= @YesterdayLocalDate 
				AND T.ResponseCode='0000') AS S
		INNER JOIN [dbo].[Merchant] M ON S.MerchantCode = M.IdentityCode
		GROUP BY [TranLocalDate],[ProgramCode], ProductId, M.Id, [TranType]

		SELECT 
           T.AccountNumber
		   ,T.ProgramCode
		   ,T.MerchantCode
		   ,HostSSN
		   ,TerminalSSN
		   ,[TranUtcDateTimeL]
		   ,[TranUtcDateTime]
		   ,T.TranLocalDate
		   ,TranLocalDateTime
		   ,TranTerminalDateTime
		   ,SettleDate
		   ,ShopCode
		   ,TerminalCode
		   ,T.TranType
		   ,[Status]
		   ,T.TranAmount
		   ,RefundedAmount
		   ,ResponseCode
		   ,1 AS [IsCleared]
		   ,NodeNum
		   ,CallerIP
		   ,Channel
		   ,[Parameters]
		   ,T.TranCode
		   ,TranCodeRef
		   ,TranGUID
		   ,TranGUIDRef
		   ,ModifyVersion
		   ,BalanceAvailable
		   ,BalanceFrozen
		   ,[Checksum]
		   ,SecurityKeyId
		   ,Rsv1
		   ,Rsv2
		   ,Rsv3
		   ,[TranRealDateTime]
		   ,[TranUtcDate]
		INTO #TransactionTemp
		FROM [dbo].[Transaction] T
		WHERE T.TranLocalDate <= @YesterdayLocalDate 
			AND T.ProgramCode = @ProgramCode

		INSERT INTO [dbo].[TransactionHistory]
           ([AccountNumber]
		   ,[ProgramCode]
		   ,[MerchantCode]
		   ,[HostSSN]
		   ,[TerminalSSN]
		   ,[TranUtcDateTimeL]
		   ,[TranUtcDateTime]
		   ,[TranLocalDate]
		   ,[TranLocalDateTime]
		   ,[TranTerminalDateTime]
		   ,SettleDate
		   ,[ShopCode]
		   ,[TerminalCode]
		   ,[TranType]
		   ,[Status]
		   ,[TranAmount]
		   ,[RefundedAmount]
		   ,[ResponseCode]
		   ,[IsCleared]
		   ,[NodeNum]
		   ,[CallerIP]
		   ,[Channel]
		   ,[Parameters]
		   ,[TranCode]
		   ,[TranCodeRef]
		   ,[TranGUID]
		   ,[TranGUIDRef]
		   ,[ModifyVersion]
		   ,[BalanceAvailable]
		   ,[BalanceFrozen]
		   ,[Checksum]
		   ,[SecurityKeyId]
		   ,[Rsv1]
		   ,[Rsv2]
		   ,[Rsv3]
		   ,[TranRealDateTime]
		   ,[TranUtcDate])
		SELECT 
           [AccountNumber]
		   ,[ProgramCode]
		   ,[MerchantCode]
		   ,[HostSSN]
		   ,[TerminalSSN]
		   ,[TranUtcDateTimeL]
		   ,[TranUtcDateTime]
		   ,[TranLocalDate]
		   ,[TranLocalDateTime]
		   ,[TranTerminalDateTime]
		   ,SettleDate
		   ,[ShopCode]
           ,[TerminalCode]
		   ,[TranType]
		   ,[Status]
		   ,[TranAmount]
		   ,[RefundedAmount]
		   ,[ResponseCode]
		   ,[IsCleared]
		   ,[NodeNum]
		   ,[CallerIP]
		   ,[Channel]
		   ,[Parameters]
		   ,[TranCode]
		   ,[TranCodeRef]
		   ,[TranGUID]
		   ,[TranGUIDRef]
		   ,[ModifyVersion]
		   ,[BalanceAvailable]
		   ,[BalanceFrozen]
		   ,[Checksum]
		   ,[SecurityKeyId]
		   ,[Rsv1]
		   ,[Rsv2]
		   ,[Rsv3]
		   ,[TranRealDateTime]
		   ,[TranUtcDate]
		FROM #TransactionTemp

		DELETE T
		FROM [dbo].[Transaction] T
		INNER JOIN #TransactionTemp TT ON T.TranCode = TT.TranCode AND T.AccountNumber = TT.AccountNumber

		DROP TABLE #TransactionTemp

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