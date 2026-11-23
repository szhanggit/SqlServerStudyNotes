CREATE PROCEDURE [dbo].[spReverseActivatePreIssuedTransactionGeneration]  
 @ErrorMessage   nvarchar(4000) OUTPUT  
 ,@ErrorLine    int    OUTPUT  
AS  
BEGIN  
  
IF NOT EXISTS (SELECT * FROM AccountToGenReverseActivatePreIssuedTran WHERE ProcessCode IS NULL)  
BEGIN  
 RETURN  
END  
  
declare @DefaultMerchantCode varchar(20)  
declare @ProcessCode varchar(50)  
declare @TranUtcDateTime datetime  
declare @TranUtcDate int  
declare @TranUtcDateTimeL bigint  
declare @TranUtcDateTime5MinutesBefore datetime  
declare @TranUtcDateTime5MinutesBeforeL bigint  
declare @tempHostSSN varchar(50)
  
select @DefaultMerchantCode = '000000000000000'  
      ,@ProcessCode=cast(NEWID() as varchar(50))  
   ,@TranUtcDateTime = GETUTCDATE()  
   ,@TranUtcDateTime5MinutesBefore =DATEADD(MINUTE,-5, GETUTCDATE())  
  
select @TranUtcDate = cast(convert(varchar(8), @TranUtcDateTime, 112) as int)  
      ,@TranUtcDateTimeL= cast(replace(convert(varchar(8), @TranUtcDateTime, 112)+convert(varchar(8), @TranUtcDateTime, 114), ':','') as bigint)  
   ,@TranUtcDateTime5MinutesBeforeL= cast(replace(convert(varchar(8), @TranUtcDateTime5MinutesBefore, 112)+convert(varchar(8), @TranUtcDateTime5MinutesBefore, 114), ':','') as bigint)  
  
create table #tmp_hostssn(AccountNumber varchar(50)  
                         ,ProgramCode varchar(20)  
						 ,TranType smallint  
						 ,HostSSN varchar(12)  
						 ,TranCodeRef VARCHAR(50)
						 ,TranCode VARCHAR(50))  
BEGIN TRY  
BEGIN TRAN  
  
--mark 401/402 as 9999 before sync  
UPDATE t2 SET ResponseCode = '9999',Parameters = 'Reverse'  
FROM AccountToGenReverseActivatePreIssuedTran AS t1 with(readpast)  
JOIN dbo.[Transaction] AS t2  ON t1.AccountNumber = t2.AccountNumber AND t1.ProgramCode = t2.ProgramCode  
JOIN Program AS p with(nolock) ON p.IdentityCode = t1.ProgramCode  
JOIN Account AS t3 with(nolock) ON t3.AccountNumber = t2.AccountNumber AND p.Id = t3.ProgramId  
WHERE t2.TranType IN (401, 402) AND t2.Status = 1 AND t1.CreatedOn >= t2.TranRealDateTime   
AND t1.ProcessCode IS NULL AND t2.ResponseCode = '0000' AND t3.Status =256 AND @TranUtcDateTime5MinutesBeforeL<t2.TranUtcDateTimeL  
  
--step1 update flag with readpassed  
UPDATE t1 SET ProcessCode = @ProcessCode,  
    ProcessedOn = @TranUtcDateTime  
FROM AccountToGenReverseActivatePreIssuedTran AS t1 with(readpast)  
JOIN dbo.[Transaction] AS t2  ON t1.AccountNumber = t2.AccountNumber AND t1.ProgramCode = t2.ProgramCode   
WHERE t2.TranType IN (401, 402) AND t2.Status = 1 AND t1.CreatedOn >= t2.TranRealDateTime AND t1.ProcessCode IS NULL   


  
--step2 generate hostssn  

  set @tempHostSSN = right(replicate('0',9)+cast(next value for HostSsn_Sequence as varchar(9)),9)
  insert into #tmp_hostssn  
  SELECT t1.AccountNumber,
		 t1.ProgramCode,
		 501,
		 @tempHostSSN, -- hostssn
		 t2.TranCode,
	     t1.ProgramCode+@DefaultMerchantCode+cast(@TranUtcDate as varchar(8))+@tempHostSSN-- +hostssn
  FROM AccountToGenReverseActivatePreIssuedTran AS t1  
  JOIN dbo.[Transaction] AS t2  ON t1.AccountNumber = t2.AccountNumber AND t1.ProgramCode = t2.ProgramCode   
 WHERE t2.TranType = 401 AND t2.Status = 1 AND t1.CreatedOn >= t2.TranRealDateTime AND t1.ProcessCode = @ProcessCode AND t2.ResponseCode = '0000'  

  set @tempHostSSN = right(replicate('0',9)+cast(next value for HostSsn_Sequence as varchar(9)),9)  
  insert into #tmp_hostssn  
  SELECT t1.AccountNumber,
         t1.ProgramCode,
         502,
         @tempHostSSN, -- hostssn
         t2.TranCode,
         t1.ProgramCode+@DefaultMerchantCode+cast(@TranUtcDate as varchar(8))+@tempHostSSN -- +hostssn
  FROM AccountToGenReverseActivatePreIssuedTran AS t1  
  JOIN dbo.[Transaction] AS t2  ON t1.AccountNumber = t2.AccountNumber AND t1.ProgramCode = t2.ProgramCode   
  WHERE t2.TranType = 402 AND t2.Status = 1 AND t1.CreatedOn >= t2.TranRealDateTime AND t1.ProcessCode = @ProcessCode AND t2.ResponseCode = '0000'  
  
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
  ,h.TranCode
  ,NEWID()  
  ,0  
  ,a.Amount  
  ,TranCodeRef  
  from AccountToGenReverseActivatePreIssuedTran a join Program p on a.ProgramCode = p.IdentityCode  
  join #tmp_hostssn h on a.AccountNumber = h.AccountNumber and a.ProgramCode=h.ProgramCode and h.TranType = 501  
  where a.ProcessCode = @ProcessCode   
  
  
 -- update latest 607/608 BatchTransactionDetail with 501 Transaction 
 update btd
 set btd.TranCodeRef = h.TranCodeRef,
     btd.TranCode = h.TranCode
   from AccountToGenReverseActivatePreIssuedTran a 
   join #tmp_hostssn h on a.AccountNumber = h.AccountNumber and a.ProgramCode = h.ProgramCode and h.TranType = 501  
  cross apply
  (
	  select top 1 *
	  from BatchTransactionDetail btd with(nolock)
	  where a.AccountNumber = btd.VoucherNumber and TranType in (607,608)
	  order by id desc
  ) btd 
  
  
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
   join #tmp_hostssn h on a.AccountNumber = h.AccountNumber and a.ProgramCode=h.ProgramCode and h.TranType = 502  
   where a.ProcessCode = @ProcessCode  
     
UPDATE t2 SET Status = 2  
FROM AccountToGenReverseActivatePreIssuedTran AS t1   
JOIN dbo.[Transaction] AS t2  ON t1.AccountNumber = t2.AccountNumber AND t1.ProgramCode = t2.ProgramCode   
WHERE t2.TranType IN (401, 402) AND t2.Status = 1 AND t1.CreatedOn >= t2.TranRealDateTime AND t1.ProcessCode = @ProcessCode AND t2.ResponseCode = '0000'  
      
--step5 Delete From Temp table  
  delete from AccountToGenReverseActivatePreIssuedTran with(readpast)  
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