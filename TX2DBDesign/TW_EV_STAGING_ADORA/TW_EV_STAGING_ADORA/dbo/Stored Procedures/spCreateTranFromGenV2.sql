CREATE PROCEDURE dbo.spCreateTranFromGenV2
	@BusinessUnit	VARCHAR(50)
	,@SessionId		VARCHAR(50)
	,@ErrorMessage	NVARCHAR(4000)	OUTPUT
	,@ErrorLine		INT				OUTPUT
AS
BEGIN	
	DECLARE @DefaultMerchantCode VARCHAR(20) = '000000000000000'
	DECLARE @TranUtcDateTime DATETIME =  GETUTCDATE()
	DECLARE @TranUtcDate INT = CONVERT(INT, FORMAT(@TranUtcDateTime, 'yyyyMMdd'))
	DECLARE @TranUtcDateTimeL BIGINT = CONVERT(BIGINT, FORMAT(@TranUtcDateTime, 'yyyyMMddHHmmss'))

	BEGIN TRY
	BEGIN TRAN
		UPDATE TOP(1500) dbo.AccountToGenTranV2 WITH(READPAST)
			SET SessionId = @SessionId
			WHERE PlanDateTime < @TranUtcDateTime
		IF @@ROWCOUNT = 0
		BEGIN
			COMMIT;
			RETURN;
		END

		--HostSSN无法在设置Top的Update里更新
		UPDATE dbo.AccountToGenTranV2
			SET HostSSN = RIGHT(replicate('0',9) + CAST(next value for HostSsn_Sequence as varchar(9)),9)
			WHERE SessionId = @SessionId

		INSERT INTO [dbo].[Transaction]
				([AccountNumber]
				,[ProgramCode]
				,[MerchantCode]
				,[HostSSN]
				,[TerminalSSN]
				,[TranUtcDate]
				,[TranUtcDateTimeL]
				,[TranUtcDateTime]
				,[TranLocalDate]
				,[TranLocalDateTime]
				,[TranRealDateTime]
				,[TranType]
				,[TranAmount]
				,[ResponseCode]
				,[TranCode]
				,[TranGUID]
				,[ModifyVersion]
				,[BalanceAvailable])
		SELECT a.AccountNumber
				,a.ProgramCode
				,@DefaultMerchantCode
				,a.HostSSN
				, NEWID()
				,@TranUtcDate
				,@TranUtcDateTimeL
				,@TranUtcDateTime
				,dbo.fnCalcLocalDate(a.PlanDateTime,p.TimeOffset)
				,dbo.fnCalcLocalDatetime(a.PlanDateTime,p.TimeOffset)
				,a.PlanDateTime
				,a.TranType
				,a.TranAmount
				,'0000'
				,a.ProgramCode+@DefaultMerchantCode+cast(@TranUtcDate as varchar(8))+a.HostSSN
				,NEWID()
				,0
				,a.TranAmount
			FROM dbo.AccountToGenTranV2 a WITH(NOLOCK) 
			JOIN dbo.Program p WITH(NOLOCK) ON a.ProgramCode = p.IdentityCode
			where a.SessionId = @SessionId 

		IF @BusinessUnit = 'TW'
		BEGIN
			INSERT dbo.AccountLETransBuffer(AccountNumber, ProgramCode, TranCode, SessionId, MerchantCode, TranLocalDate)
				SELECT	a.AccountNumber,
						a.ProgramCode,
						a.ProgramCode+@DefaultMerchantCode+cast(@TranUtcDate as varchar(8))+a.HostSSN,
						@SessionId,
						@DefaultMerchantCode,
						dbo.fnCalcLocalDate(a.PlanDateTime,p.TimeOffset)
					FROM dbo.AccountToGenTranV2 a WITH(NOLOCK)
					JOIN dbo.Program p WITH(NOLOCK) ON a.ProgramCode = p.IdentityCode
					where a.SessionId = @SessionId AND a.TranType = 402 AND DATEDIFF(YEAR, DATEADD(YEAR, 100, a.PlanDateTime), a.ActiveTo) > 0
			IF @@ROWCOUNT > 0
			BEGIN
				INSERT dbo.AccountLEBuffer(AccountNumber, ProgramId, BalanceAvailable, ActivatedOn, TranType) 
					SELECT 
						a.AccountNumber,
						p.Id,
						a.TranAmount,
						DATEADD(ss,-1,CONVERT(datetime, CONVERT(date, DATEADD(DAY, 1, a.PlanDateTime)))) as ActivatedOn,
						a.TranType
					FROM dbo.AccountToGenTranV2 a WITH(NOLOCK)
					JOIN dbo.Program p WITH(NOLOCK) ON a.ProgramCode = p.IdentityCode
					where a.SessionId = @SessionId AND a.TranType = 402 AND DATEDIFF(YEAR, DATEADD(YEAR, 100, a.PlanDateTime), a.ActiveTo) > 0
			END
		END

		DELETE FROM dbo.AccountToGenTranV2 WHERE SessionId = @SessionId

		COMMIT
	END TRY 
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE()
		SELECT @ErrorLine = ERROR_LINE()
		ROLLBACK
	END CATCH 
END