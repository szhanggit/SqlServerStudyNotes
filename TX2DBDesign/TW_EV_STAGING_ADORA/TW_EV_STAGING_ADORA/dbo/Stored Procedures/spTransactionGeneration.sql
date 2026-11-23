CREATE PROCEDURE dbo.spTransactionGeneration
	@BusinessUnit varchar(50)
	,@SessionId varchar(50)
	,@ErrorMessage			nvarchar(4000)	OUTPUT
	,@ErrorLine				int				OUTPUT
AS
BEGIN

IF NOT EXISTS(SELECT 1 FROM dbo.AccountToGenTran WITH(NOLOCK))
	RETURN;

DECLARE @inserted table ([AccountNumber] varchar(50), [ProgramCode] varchar(20), [TranCode] varchar(50), MerchantCode VARCHAR (50), TranLocalDate INT);
declare @DefaultMerchantCode varchar(20)
declare @ProcessCode varchar(50)
declare @TranUtcDateTime datetime
declare @TranUtcDate int
declare @TranUtcDateTimeL bigint
select @DefaultMerchantCode = '000000000000000'
      ,@ProcessCode=cast(NEWID() as varchar(50))
	  ,@TranUtcDateTime = GETUTCDATE()

select @TranUtcDate = cast(convert(varchar(8), @TranUtcDateTime, 112) as int)
      ,@TranUtcDateTimeL= cast(replace(convert(varchar(8), @TranUtcDateTime, 112)+convert(varchar(8), @TranUtcDateTime, 114), ':','') as bigint)

create table #tmp_hostssn(AccountNumber varchar(50)
                         ,ProgramCode varchar(20)
						 ,TranType smallint
						 ,HostSSN varchar(12))
BEGIN TRY
BEGIN TRAN
--step1 update flag with readpassed

  update TOP(1500) AccountToGenTran with(readpast)
  set ProcessCode = @ProcessCode,
      ProcessedOn = @TranUtcDateTime
  where ProcessCode is null

--step2 generate hostssn
  insert into #tmp_hostssn
  select AccountNumber,ProgramCode,401,right(replicate('0',9)+cast(next value for HostSsn_Sequence as varchar(9)),9)
  from AccountToGenTran with(nolock)
  where ProcessCode = @ProcessCode

  insert into #tmp_hostssn
  select AccountNumber,ProgramCode,402,right(replicate('0',9)+cast(next value for HostSsn_Sequence as varchar(9)),9)
  from AccountToGenTran with(nolock)
  where ProcessCode = @ProcessCode

--step3 Insert Issue Transaction (401)
  
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
  select a.AccountNumber
        ,a.ProgramCode
		,@DefaultMerchantCode
		,h.HostSSN
		, NEWID()
		,@TranUtcDate
		,@TranUtcDateTimeL
		,@TranUtcDateTime
		,dbo.fnCalcLocalDate(a.CreatedOn,p.TimeOffset)
		,dbo.fnCalcLocalDatetime(a.CreatedOn,p.TimeOffset)
		,a.CreatedOn
		,401
		,a.Amount
		,'0000'
		,a.ProgramCode+@DefaultMerchantCode+cast(@TranUtcDate as varchar(8))+h.HostSSN
		,NEWID()
		,0
		,a.Amount
  from AccountToGenTran a with(nolock) join Program p on a.ProgramCode = p.IdentityCode
  join #tmp_hostssn h on a.AccountNumber = h.AccountNumber and a.ProgramCode=h.ProgramCode and h.TranType = 401
  where a.ProcessCode = @ProcessCode 


--step4 Insert Active Transaction (402)
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
			OUTPUT INSERTED.[AccountNumber], INSERTED.[ProgramCode], INSERTED.[TranCode], INSERTED.[MerchantCode], INSERTED.[TranLocalDate]
			INTO @inserted	
	  select a.AccountNumber
			,a.ProgramCode
			,@DefaultMerchantCode
			,h.HostSSN
			, NEWID()
			,@TranUtcDate
			,@TranUtcDateTimeL
			,@TranUtcDateTime
			,dbo.fnCalcLocalDate(a.CreatedOn,p.TimeOffset)
			,dbo.fnCalcLocalDatetime(a.CreatedOn,p.TimeOffset)
			,a.CreatedOn
			,402
			,a.Amount
			,'0000'
			,a.ProgramCode+@DefaultMerchantCode+cast(@TranUtcDate as varchar(8))+h.HostSSN
			,NEWID()
			,0
			,a.Amount
	  from AccountToGenTran a with(nolock) join Program p on a.ProgramCode = p.IdentityCode
	  join #tmp_hostssn h on a.AccountNumber = h.AccountNumber and a.ProgramCode=h.ProgramCode and h.TranType = 402
	  where a.ProcessCode = @ProcessCode 

	IF @BusinessUnit = 'TW'
	begin
		INSERT INTO AccountLETransBuffer (AccountNumber, ProgramCode, TranCode, SessionId, MerchantCode, TranLocalDate)
		select AccountNumber, ProgramCode, TranCode, @SessionId as SessionId, MerchantCode, TranLocalDate from @inserted;

		INSERT into AccountLEBuffer (AccountNumber, ProgramId, BalanceAvailable, ActivatedOn, TranType) 
		select a.AccountNumber, a.ProgramId, a.BalanceAvailable, DATEADD(ss,-1,CONVERT(datetime, CONVERT(date, DATEADD(DAY, 1, a.ActiveFrom)))) as ActivatedOn, 402 as TranType
		from Account a with(nolock) 
		INNER join (
		select buf.AccountNumber, p.Id AS ProgramId, buf.TranCode, buf.SessionId, buf.MerchantCode, buf.TranLocalDate 
		from AccountLETransBuffer buf WITH(NOLOCK) 
		INNER JOIN Program p WITH(NOLOCK) ON buf.ProgramCode = p.IdentityCode
		where buf.SessionId = @SessionId
		) t		
		ON a.AccountNumber = t.AccountNumber AND a.ProgramId = t.ProgramId
		WHERE DATEDIFF(YEAR, DATEADD(year, 100, a.ActiveFrom), a.ActiveTo) > 0

	end

--step5 Delete From Temp table
  delete from AccountToGenTran with(readpast)
  where ProcessCode = @ProcessCode

  drop table #tmp_hostssn
COMMIT TRAN

END TRY 
BEGIN CATCH
  SELECT @ErrorMessage = ERROR_MESSAGE()
  SELECT @ErrorLine = ERROR_LINE()
  ROLLBACK TRAN
END CATCH 
END;