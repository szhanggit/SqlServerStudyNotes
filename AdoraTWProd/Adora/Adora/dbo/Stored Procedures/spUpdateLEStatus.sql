
CREATE PROCEDURE dbo.spUpdateLEStatus
@AccountNumber varchar(50), 
@ProgramId INT, 
@TranType INT,
@TranCode varchar(50), 
@TranAmount INT,
@MerchantCode	VARCHAR (50) = NULL,
@AvailableBalance INT,
@ActiveFrom DATETIME = NULL,
@SettleDate		INT = NULL,
@TranLocalDate	INT = NULL
AS
BEGIN
	--LEStatus = 0 初始状态
	--LEStatus = 1 需要做LE交易的Account
	--LEStatus = 2 已经做了LE Transaction
	--LEStatus = 3 需要做reverse LE交易的Account
	--LEStatus = 4 已经做了reverse LE Transaction
	--LEStatus = 5 无需做LE交易(已经Redeem、Trash等)
	SET NOCOUNT ON;
	DECLARE @MaxDay DateTime = '2899-01-01';
	DECLARE @FinanceExpireDate DateTime;
	DECLARE @AccountLEId INT;
	DECLARE @AccountActiveTo DateTime;
	select @AccountLEId = Id from AccountLE with(nolock) 
	where AccountNumber = @AccountNumber 
	  AND ProgramId = @ProgramId;	

	if @ActiveFrom is not null
	begin
		UPDATE dbo.AccountLE 
		SET FinanceExpireDate = DATEADD(DAY,FinanceExpireDays,CONVERT(NVARCHAR(10), @ActiveFrom, 120) + ' 23:59:59.000') 
		WHERE AccountNumber = @AccountNumber AND ProgramId = @ProgramId;

		insert into AccountLETrans (AccountLEId, TranBalanceAvailable, TranAmount, TranType, TransLEStatus, TranCode, CeatedDate, MerchantCode , SettleDate, TranLocalDate)
		values (@AccountLEId, @AvailableBalance, @TranAmount, @TranType, 0, @TranCode, getDate(), @MerchantCode , @SettleDate, @TranLocalDate);	
	end
	
	--Start for maintain AvailableBalance for TranLEStatus = 0.
	if exists(select * from AccountLETrans les with(nolock)
	inner join AccountLE le with(nolock) on les.AccountLEId = le.Id
	where le.AccountNumber = @AccountNumber AND le.ProgramId = @ProgramId AND les.TransLEStatus = 0)
	begin
		update AccountLE
		set BalanceAvailable = @AvailableBalance
		where AccountNumber = @AccountNumber AND ProgramId = @ProgramId
	end
	--End for maintain AvailableBalance for TranLEStatus = 0.
	
	select @FinanceExpireDate = FinanceExpireDate from dbo.AccountLE with(nolock) WHERE AccountNumber = @AccountNumber AND ProgramId = @ProgramId	
	select @AccountActiveTo = ActiveTo from dbo.Account with(nolock) WHERE AccountNumber = @AccountNumber AND ProgramId = @ProgramId	
	--Vouchers which can generate L&E transactions, must have very big ActiveTo date. It means no expiry date. 
	--Meanwhile, FinanceExpireDate must be less than today.
	if (ISNULL(@FinanceExpireDate, @MaxDay)) <= GETUTCDATE() AND (@AccountActiveTo > @MaxDay)
	begin
		--Redemption PreAuthorizationComplete TrashMoney TrashNoMoney
		IF (@TranType = 101 OR @TranType = 103 OR @TranType = 404 OR @TranType = 405)
		BEGIN
			insert into AccountLETrans (AccountLEId, TranBalanceAvailable, TranAmount, TranType, TransLEStatus, TranCode, CeatedDate, MerchantCode , SettleDate, TranLocalDate)
			values (@AccountLEId, @AvailableBalance, @TranAmount, @TranType, 3, @TranCode, getDate(), @MerchantCode , @SettleDate, @TranLocalDate);	  
		END

		IF (@TranType = 201 OR @TranType = 203 OR @TranType = 402)
		BEGIN
			insert into AccountLETrans (AccountLEId, TranBalanceAvailable, TranAmount, TranType, TransLEStatus, TranCode, CeatedDate, MerchantCode , SettleDate, TranLocalDate)
			values (@AccountLEId, @AvailableBalance, @TranAmount, @TranType, 1, @TranCode, getDate(), @MerchantCode , @SettleDate, @TranLocalDate);		
		END
	end
END

