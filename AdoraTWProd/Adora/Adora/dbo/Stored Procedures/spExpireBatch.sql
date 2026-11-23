-- =============================================
-- Author:		Jianhua Zhu
-- Create date: 2016/09/29
-- Description:	This is used to expire account.
-- =============================================
CREATE PROCEDURE [dbo].[spExpireBatch]
	@SessionId			VARCHAR(50)
	,@ErrorMessage		VARCHAR(4000)	OUTPUT
	,@ErrorLine			INT				OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #tmp_hostssn(AccountNumber VARCHAR(50)
                         ,ProgramId INT
						 ,HostSSN VARCHAR(12))

	BEGIN TRAN

	BEGIN TRY
		UPDATE [dbo].[Account]
		SET [LastTranOn] = AEB.[LastTranOn]
			,[ModifyVersion] = AEB.[ModifyVersion] + 1
			,[Checksum] = AEB.[Checksum]
			,[Status] = 4
		FROM [dbo].[AccountExpireBuffer] AS AEB 
		WHERE [Account].[AccountNumber] = AEB.AccountNumber 
		AND [Account].[ProgramId] = AEB.[ProgramId] 
		AND [Account].[ModifyVersion] = AEB.ModifyVersion
		AND AEB.SessionId = @SessionId
		
		INSERT INTO #tmp_hostssn
		SELECT A.AccountNumber
			,A.ProgramId
			,RIGHT(REPLICATE('0',9)+CAST(NEXT value FOR HostSsn_Sequence AS VARCHAR(9)),9)
		FROM [dbo].[Account] AS A
		INNER JOIN [dbo].[AccountExpireBuffer] AS AEB ON A.AccountNumber = AEB.AccountNumber
					AND A.ProgramId = AEB.ProgramId
		WHERE AEB.SessionId = @SessionId
		AND A.ModifyVersion = AEB.[ModifyVersion] + 1

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
			,[TranRealDateTime]
			,[ResponseCode]
			,[TranLocalDate]
			,[TranLocalDateTime])
		SELECT TEB.AccountNumber
				,TEB.ProgramCode
				,'000000000000000'
				,TEB.TranUtcDate
				,TH.HostSSN
				,TH.HostSSN
				,TEB.TranUtcDateTimeL
				,TEB.TranUtcDateTime
				,403
				,TEB.TranAmount
				,TEB.ProgramCode + '000000000000000' + CONVERT(varchar(8) , TEB.TranUtcDateTime, 112) + TH.HostSSN
				,NEWID()
				,TEB.[ModifyVersion]
				,TEB.[BalanceAvailable]
				,TEB.[BalanceFrozen]
				,TEB.[TranRealDateTime]
				,'0000'
				,TEB.TranLocalDate
				,TEB.TranLocalDateTime
		FROM [dbo].[TransactionExpireBuffer] AS TEB
		JOIN #tmp_hostssn AS TH ON TEB.AccountNumber = TH.AccountNumber
				AND TEB.ProgramId = TH.ProgramId
		JOIN [dbo].[Account] AS A ON TEB.AccountNumber = A.AccountNumber
				AND TEB.ProgramId = A.ProgramId
		JOIN [dbo].[AccountExpireBuffer] AS AEB ON A.AccountNumber = AEB.AccountNumber
				AND A.ProgramId = AEB.ProgramId
		WHERE AEB.SessionId = @SessionId
		AND TEB.SessionId = @SessionId
		AND A.[Status] = 4
		AND A.ModifyVersion = AEB.[ModifyVersion] + 1
		
		DELETE [dbo].[AccountExpireBuffer]
		WHERE SessionId = @SessionId

		DELETE [dbo].[TransactionExpireBuffer]
		WHERE SessionId = @SessionId

		IF EXISTS (SELECT 1 FROM SYSOBJECTS WHERE name = '#tmp_hostssn' )
			DROP TABLE #tmp_hostssn

	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE()
		SELECT @ErrorLine = ERROR_LINE()

		IF EXISTS (SELECT 1 FROM SYSOBJECTS WHERE name = '#tmp_hostssn' )
			DROP TABLE #tmp_hostssn

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

			declare @errorSeverity int
					,@errorState int

			select @errorMessage = ERROR_MESSAGE()	
					,@errorSeverity = ERROR_SEVERITY()
					,@errorState = ERROR_STATE()	

			/*抛出一个异常*/
			raiserror (@errorMessage,@errorSeverity,@errorState)
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END

