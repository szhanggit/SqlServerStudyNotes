
CREATE PROCEDURE spReverseActivatedTransactionGeneration
	-- Add the parameters for the stored procedure here
	@ErrorMessage	nvarchar(4000)	OUTPUT
	,@ErrorLine	int		OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
IF NOT EXISTS (SELECT * FROM AccountToGenReverseActivatePreIssuedTran WHERE ProcessCode IS NULL)
BEGIN
 RETURN
END

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

create table #tmp(AccountNumber varchar(50)
                         ,ProgramCode varchar(20)
			 ,TranType smallint
			 ,HostSSN varchar(12)
			 ,TranCodeRef VARCHAR(50))
BEGIN TRY
BEGIN TRAN
--step1 update flag with readpassed

UPDATE t1 SET	ProcessCode = @ProcessCode,
		ProcessedOn = @TranUtcDateTime
FROM AccountToGenReverseActivatePreIssuedTran AS t1 with(readpast)
JOIN dbo.[Transaction] AS t2 	ON t1.AccountNumber = t2.AccountNumber AND t1.ProgramCode = t2.ProgramCode 
WHERE t2.TranType IN (401, 402) AND t2.Status = 1 AND t1.CreatedOn >= t2.TranRealDateTime AND t1.ProcessCode IS NULL

UPDATE t1 SET	ProcessCode = @ProcessCode,
		ProcessedOn = @TranUtcDateTime
FROM AccountToGenReverseActivatePreIssuedTran AS t1 with(readpast)
JOIN dbo.[TransactionHistory] AS t2 	ON t1.AccountNumber = t2.AccountNumber AND t1.ProgramCode = t2.ProgramCode 
WHERE t2.TranType IN (401, 402) AND t2.Status = 1 AND t1.CreatedOn >= t2.TranRealDateTime AND t1.ProcessCode IS NULL


--step2 generate hostssn
  insert into #tmp
  SELECT t1.AccountNumber,t1.ProgramCode,501,right(replicate('0',9)+cast(next value for HostSsn_Sequence as varchar(9)),9), t2.TranCode
  FROM AccountToGenReverseActivatePreIssuedTran AS t1
  JOIN dbo.[Transaction] AS t2 	ON t1.AccountNumber = t2.AccountNumber AND t1.ProgramCode = t2.ProgramCode 
  WHERE t2.TranType = 401 AND t2.Status = 1 AND t1.CreatedOn >= t2.TranRealDateTime AND t1.ProcessCode = @ProcessCode

  insert into #tmp
  SELECT t1.AccountNumber,t1.ProgramCode,501,right(replicate('0',9)+cast(next value for HostSsn_Sequence as varchar(9)),9), t2.TranCode
  FROM AccountToGenReverseActivatePreIssuedTran AS t1
  JOIN dbo.[TransactionHistory] AS t2 	ON t1.AccountNumber = t2.AccountNumber AND t1.ProgramCode = t2.ProgramCode 
  WHERE t2.TranType = 401 AND t2.Status = 1 AND t1.CreatedOn >= t2.TranRealDateTime AND t1.ProcessCode = @ProcessCode

  insert into #tmp
  SELECT t1.AccountNumber,t1.ProgramCode,502,right(replicate('0',9)+cast(next value for HostSsn_Sequence as varchar(9)),9), t2.TranCode
  FROM AccountToGenReverseActivatePreIssuedTran AS t1
  JOIN dbo.[Transaction] AS t2  ON t1.AccountNumber = t2.AccountNumber AND t1.ProgramCode = t2.ProgramCode 
  WHERE t2.TranType = 402 AND t2.Status = 1 AND t1.CreatedOn >= t2.TranRealDateTime AND t1.ProcessCode = @ProcessCode

  insert into #tmp
  SELECT t1.AccountNumber,t1.ProgramCode,502,right(replicate('0',9)+cast(next value for HostSsn_Sequence as varchar(9)),9), t2.TranCode
  FROM AccountToGenReverseActivatePreIssuedTran AS t1
  JOIN dbo.[TransactionHistory] AS t2  ON t1.AccountNumber = t2.AccountNumber AND t1.ProgramCode = t2.ProgramCode 
  WHERE t2.TranType = 402 AND t2.Status = 1 AND t1.CreatedOn >= t2.TranRealDateTime AND t1.ProcessCode = @ProcessCode

--step3 Insert Issue Transaction (501)
  
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
			,[BalanceAvailable]
			, TranCodeRef)
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
		,501
		,a.Amount
		,'0000'
		,a.ProgramCode+@DefaultMerchantCode+cast(@TranUtcDate as varchar(8))+h.HostSSN
		,NEWID()
		,0
		,a.Amount
		,TranCodeRef
  from AccountToGenReverseActivatePreIssuedTran a join Program p on a.ProgramCode = p.IdentityCode
  join #tmp h on a.AccountNumber = h.AccountNumber and a.ProgramCode=h.ProgramCode and h.TranType = 501
  where a.ProcessCode = @ProcessCode 


--step4 Insert Active Transaction (502)
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
				,[BalanceAvailable]
				,TranCodeRef)
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
			,502
			,a.Amount
			,'0000'
			,a.ProgramCode+@DefaultMerchantCode+cast(@TranUtcDate as varchar(8))+h.HostSSN
			,NEWID()
			,0
			,a.Amount
			,TranCodeRef
	  from AccountToGenReverseActivatePreIssuedTran a join Program p on a.ProgramCode = p.IdentityCode
	  join #tmp h on a.AccountNumber = h.AccountNumber and a.ProgramCode=h.ProgramCode and h.TranType = 502
	  where a.ProcessCode = @ProcessCode
	  
UPDATE t2 SET	Status = 2
FROM AccountToGenReverseActivatePreIssuedTran AS t1 
JOIN dbo.[Transaction] AS t2 	ON t1.AccountNumber = t2.AccountNumber AND t1.ProgramCode = t2.ProgramCode 
WHERE t2.TranType IN (401, 402) AND t2.Status = 1 AND t1.CreatedOn >= t2.TranRealDateTime AND t1.ProcessCode = @ProcessCode

UPDATE t2 SET	Status = 2
FROM AccountToGenReverseActivatePreIssuedTran AS t1 
JOIN dbo.[TransactionHistory] AS t2 	ON t1.AccountNumber = t2.AccountNumber AND t1.ProgramCode = t2.ProgramCode 
WHERE t2.TranType IN (401, 402) AND t2.Status = 1 AND t1.CreatedOn >= t2.TranRealDateTime AND t1.ProcessCode = @ProcessCode
	   
--step5 Delete From Temp table
  delete from AccountToGenReverseActivatePreIssuedTran with(readpast)
  where ProcessCode = @ProcessCode

  drop table #tmp
COMMIT TRAN

END TRY 
BEGIN CATCH
  SELECT @ErrorMessage = ERROR_MESSAGE()
  SELECT @ErrorLine = ERROR_LINE()
  ROLLBACK TRAN
END CATCH 

END;