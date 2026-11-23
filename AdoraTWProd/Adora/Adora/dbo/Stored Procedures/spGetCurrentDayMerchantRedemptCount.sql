-- =============================================
-- Author:		Knight YAO
-- Create date: 2016/8/8
-- Description:	spGetCurrentDayMerchantRedemptCount
-- =============================================
CREATE PROCEDURE spGetCurrentDayMerchantRedemptCount
	@ProgramCode		varchar(20)
	,@MerchantCode		varchar(50)
	,@ShopCode          varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--get current date in 
	Declare @TimeOffset Varchar(20), @CurrentLocalTime Datetime
	Declare @LocalStartTime Datetime, @UTCStartTime DateTime
	Declare @LocalEndTime DateTime,   @UTCEndTime DateTime
	Declare @StartTranUtcDateTimeL bigint,@EndTranUtcDateTimeL bigint

  if(isnull(@ProgramCode,'')='')
  Begin
    Select @ProgramCode = p.IdentityCode
    From Merchant m join Program p on m.ProgramId = p.Id
    where m.IdentityCode = @MerchantCode
  End
  
	Select @TimeOffset = TimeOffset
	From Program 
	Where IdentityCode = @ProgramCode

	if(left(@TimeOffset,1)='-')
		Set @CurrentLocalTime = GETUTCDATE() - Substring(@TimeOffset,2,len(@TimeOffset)-1)
	else
		Set @CurrentLocalTime = GETUTCDATE() + @TimeOffset

	select @LocalStartTime = Convert(datetime,CONVERT(varchar(50),@CurrentLocalTime,112),112)
	select @LocalEndTime = DATEADD(s,-1,DATEADD(DAY,1,@LocalStartTime))

	if(left(@TimeOffset,1)='-')
		Select @UTCStartTime = @LocalStartTime + Substring(@TimeOffset,2,len(@TimeOffset)-1),
			   @UTCEndTime = @LocalEndTime + Substring(@TimeOffset,2,len(@TimeOffset)-1)
	else
		Select @UTCStartTime = @LocalStartTime - @TimeOffset,
			   @UTCEndTime = @LocalEndTime - @TimeOffset

	select @StartTranUtcDateTimeL = cast(replace(convert(varchar(8), @UTCStartTime, 112)+convert(varchar(8), @UTCStartTime, 114), ':','') as bigint)
		  ,@EndTranUtcDateTimeL = cast(replace(convert(varchar(8), @UTCEndTime, 112)+convert(varchar(8), @UTCEndTime, 114), ':','') as bigint)

    Select tmp.ProductId,
	       tmp.ProductName,
		   COUNT(*) as RecordCount 
	From
	(
		Select Distinct P.ExternalId as ProductId,p.Name as ProductName,a.ProgramId,a.AccountNumber
		From [Transaction] t with(nolock) join Account a with(nolock) on t.AccountNumber = a.AccountNumber
			 join Program pg with(nolock) on a.ProgramId = pg.Id and pg.IdentityCode = t.ProgramCode
			 join Merchant m with(nolock) on t.MerchantCode = m.IdentityCode and m.ProgramId=pg.Id
			 join Product p with(nolock) on a.ProductId = p.Id
		where t.TranUtcDateTimeL between @StartTranUtcDateTimeL and @EndTranUtcDateTimeL
		   and t.MerchantCode = @MerchantCode
		   and (ISNULL(@ShopCode,'')='' or t.ShopCode = @ShopCode)
		   and t.ResponseCode = '0000'
		   and t.TranType in (101,103)
		   and a.Status = 32
	 ) tmp
	 Group By ProductId,ProductName
	      
END
