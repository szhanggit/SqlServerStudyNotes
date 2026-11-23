CREATE PROCEDURE spQueryTransaction
  @FromL bigint
	,@ToL bigint
	,@TerminalSSN varchar(50)=null
	,@ShopCode varchar(50)=null
	,@MerchantCode varchar(20)=null
	,@PageSize int
	,@PageIndex int
	,@Status varchar(10) = null
	,@TranType smallint = null
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @tableCount int
  DECLARE @table TABLE(TranCode varchar(50),
    Status varchar(5),
    MerchantCode varchar(20),
    ShopCode varchar(50),
    TerminalSSN varchar(50),
    TranAmount int,
    TranUtcDateTime datetime,
    AccountNumber varchar(50),
    BalanceAvailable int,
    TranType smallint,
    ProgramCode varchar(20))
  insert into @table
  select t.TranCode, t.ResponseCode, t.MerchantCode, t.ShopCode, t.TerminalSSN, t.TranAmount, t.TranUtcDateTime, t.AccountNumber, t.BalanceAvailable, t.TranType, t.ProgramCode
  FROM [dbo].[Transaction] t WITH(nolock)
  where t.TranUtcDateTimeL between @FromL and @ToL
    and (@MerchantCode is null or t.MerchantCode = @MerchantCode )
    and (@TerminalSSN is null or t.TerminalSSN = @TerminalSSN)
    and (@ShopCode is null or t.ShopCode = @ShopCode)
    and (@Status is null or ( @Status = 'SUCCESSFUL' and t.ResponseCode = '0000') or (@Status = 'FAILED' and t.ResponseCode <> '0000'))
    and (@TranType is null or t.TranType = @TranType)
  order by t.TranUtcDateTimeL desc
  offset @PageIndex*@PageSize rows fetch next @PageSize rows only

  select @tableCount= count(1)
  from @table


  If @tableCount>0 and @tableCount <@PageSize 

insert into @table
  select top (@PageSize-@tableCount)
    t.TranCode, t.ResponseCode, t.MerchantCode, t.ShopCode, t.TerminalSSN, t.TranAmount, t.TranUtcDateTime, t.AccountNumber, t.BalanceAvailable, t.TranType, t.ProgramCode
  FROM [dbo].[TransactionHistory] t WITH(nolock)
  where t.TranUtcDateTimeL between @FromL and @ToL
    and (@MerchantCode is null or t.MerchantCode = @MerchantCode )
    and (@TerminalSSN is null or t.TerminalSSN = @TerminalSSN)
    and (@ShopCode is null or t.ShopCode = @ShopCode)
    and (@Status is null or ( @Status = 'SUCCESSFUL' and t.ResponseCode = '0000') or (@Status = 'FAILED' and t.ResponseCode <> '0000'))
    and (@TranType is null or t.TranType = @TranType)
  order by t.TranUtcDateTimeL desc
  else if @tableCount=0
  begin
    select @tableCount= count(1)
    FROM [dbo].[Transaction] t WITH(nolock)
    where t.TranUtcDateTimeL between @FromL and @ToL
      and (@MerchantCode is null or t.MerchantCode = @MerchantCode )
      and (@TerminalSSN is null or t.TerminalSSN = @TerminalSSN)
      and (@ShopCode is null or t.ShopCode = @ShopCode)
      and (@Status is null or t.ResponseCode = @Status)
      and (@TranType is null or t.TranType = @TranType)

    insert into @table
    select t.TranCode, t.ResponseCode, t.MerchantCode, t.ShopCode, t.TerminalSSN, t.TranAmount, t.TranUtcDateTime, t.AccountNumber, t.BalanceAvailable, t.TranType, t.ProgramCode
    FROM [dbo].[TransactionHistory] t WITH(nolock)
    where t.TranUtcDateTimeL between @FromL and @ToL
      and (@MerchantCode is null or t.MerchantCode = @MerchantCode )
      and (@TerminalSSN is null or t.TerminalSSN = @TerminalSSN)
      and (@ShopCode is null or t.ShopCode = @ShopCode)
      and (@Status is null or ( @Status = 'SUCCESSFUL' and t.ResponseCode = '0000') or (@Status = 'FAILED' and t.ResponseCode <> '0000'))
      and (@TranType is null or t.TranType = @TranType)
    order by t.TranUtcDateTimeL desc
  offset @PageIndex*@PageSize-@tableCount rows fetch next @PageSize rows only
  end

  select t.*, a.ProductId, a.ValueType, p.Name, p.ExternalProductCode as ProductCode
  from @table t
    join dbo.Program Program with(nolock) on program.IdentityCode = t.ProgramCode
    join dbo.Account a WITH(nolock) on t.AccountNumber = a.AccountNumber and program.id = a.ProgramId
    join dbo.Product p WITH(nolock) on p.Id = a.ProductId
union
select t.*, a.ProductId, a.ValueType, p.Name, p.ExternalProductCode as ProductCode
  from @table t
    join dbo.Program Program with(nolock) on program.IdentityCode = t.ProgramCode
    join dbo.AccountHistory a WITH(nolock) on t.AccountNumber = a.AccountNumber and program.id = a.ProgramId
    join dbo.Product p WITH(nolock) on p.Id = a.ProductId
END