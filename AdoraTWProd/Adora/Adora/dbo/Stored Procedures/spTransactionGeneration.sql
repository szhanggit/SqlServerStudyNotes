-- =============================================
-- Author:		Knight Yao
-- Create date: 2015/10/09
-- Description:	Generate transactions for the pre-issued vouchers which are activated by API
-- =============================================
CREATE PROCEDURE [dbo].[spTransactionGeneration]
	@ErrorMessage			nvarchar(4000)	OUTPUT
	,@ErrorLine				int				OUTPUT
AS
BEGIN

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

  update AccountToGenTran with(readpast)
  set ProcessCode = @ProcessCode,
      ProcessedOn = @TranUtcDateTime
  where ProcessCode is null

--step2 generate hostssn
  insert into #tmp_hostssn
  select AccountNumber,ProgramCode,401,right(replicate('0',9)+cast(next value for HostSsn_Sequence as varchar(9)),9)
  from AccountToGenTran
  where ProcessCode = @ProcessCode

  insert into #tmp_hostssn
  select AccountNumber,ProgramCode,402,right(replicate('0',9)+cast(next value for HostSsn_Sequence as varchar(9)),9)
  from AccountToGenTran
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
  from AccountToGenTran a join Program p on a.ProgramCode = p.IdentityCode
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
	  from AccountToGenTran a join Program p on a.ProgramCode = p.IdentityCode
	  join #tmp_hostssn h on a.AccountNumber = h.AccountNumber and a.ProgramCode=h.ProgramCode and h.TranType = 402
	  where a.ProcessCode = @ProcessCode 

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

END
