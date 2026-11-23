
CREATE PROCEDURE [dbo].[spMoveTransactionToSync]
	@BatchId BIGINT = 0,
    @IsSuccess BIT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

    IF EXISTS ( SELECT top 1 AccountNumber FROM dbo.TransactionToSync )
    BEGIN
        set @IsSuccess = 0;
        RETURN;
    END

    set @IsSuccess = 1;
    update TransactionTemp set BatchId = @BatchId where BatchId is null; 

INSERT INTO dbo.TransactionToSync
([AccountNumber]
      ,[ProgramCode]
      ,[MerchantCode]
      ,[ShopCode]
      ,[TranType]
      ,[TranLocalDate]
      ,[TranLocalDateTime]
      ,[SettleDate]
      ,[TranRealDateTime]
      ,[Status]
      ,[TranAmount]
      ,[RefundedAmount]
      ,[ResponseCode]
      ,[Channel]
      ,[TranCode]
      ,[TranCodeRef]
      ,[BalanceAvailable]
      ,[BalanceFrozen]
      ,[Rsv1]
      ,[Rsv2]
      ,[Rsv3]
      ,[TerminalSSN]
      ,[ShiftCode]
      ,[BusinessDay]
      ,[TerminalCode]
      --,[FNEV]
      ,[PreTranType]
      ,[InitBalance]
      ,[LEBalance]
      ,[LEInitBalance])
SELECT [AccountNumber]
      ,[ProgramCode]
      ,[MerchantCode]
      ,[ShopCode]
      ,[TranType]
      ,[TranLocalDate]
      ,[TranLocalDateTime]
      ,[SettleDate]
      ,[TranRealDateTime]
      ,[Status]
      ,[TranAmount]
      ,[RefundedAmount]
      ,[ResponseCode]
      ,[Channel]
      ,[TranCode]
      ,[TranCodeRef]
      ,[BalanceAvailable]
      ,[BalanceFrozen]
      ,[Rsv1]
      ,[Rsv2]
      ,[Rsv3]
      ,[TerminalSSN]
      ,[ShiftCode]
      ,[BusinessDay]
      ,[TerminalCode]
      --,[FNEV]
      ,[PreTranType]
      ,[InitBalance]
      ,[LEBalance]
      ,[LEInitBalance]
  FROM [dbo].[TransactionTemp] with(nolock)
  where BatchId = @BatchId

END

