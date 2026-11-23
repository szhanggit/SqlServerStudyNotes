
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
	--LEStatus = 0 åˆå§‹çŠ¶æ€
	--LEStatus = 1 éœ€è¦åšLEäº¤æ˜“çš„Account
	--LEStatus = 2 å·²ç»åšäº†LE Transaction
	--LEStatus = 3 éœ€è¦åšreverse LEäº¤æ˜“çš„Account
	--LEStatus = 4 å·²ç»åšäº†reverse LE Transaction
	--LEStatus = 5 æ— éœ€åšLEäº¤æ˜“(å·²ç»Redeemã€Trashç­‰)
	SET NOCOUNT ON;
	DECLARE @yesterday DATETIME = GETUTCDATE();
	DECLARE @MaxDay DateTime = '2899-01-01';
	DECLARE @FinanceExpireDate DateTime;
	DECLARE @AccountLEId INT;
	DECLARE @AccountActiveTo DateTime;
	select @AccountLEId = Id,@FinanceExpireDate = FinanceExpireDate from AccountLE with(nolock) 
	where AccountNumber = @AccountNumber 
	  AND ProgramId = @ProgramId;	

	--select @FinanceExpireDate = FinanceExpireDate from dbo.AccountLE with(nolock) WHERE AccountNumber = @AccountNumber AND ProgramId = @ProgramId	
	select @AccountActiveTo = ActiveTo from dbo.Account with(nolock) WHERE AccountNumber = @AccountNumber AND ProgramId = @ProgramId

	if (@ActiveFrom is not null) AND (@AccountActiveTo > @MaxDay)
	begin
		UPDATE dbo.AccountLE 
		SET FinanceExpireDate = DATEADD(DAY,FinanceExpireDays,CONVERT(NVARCHAR(10), @ActiveFrom, 120) + ' 15:59:59.000') 
		WHERE Id = @AccountLEId;

		insert into AccountLETrans (AccountLEId, TranBalanceAvailable, TranAmount, TranType, TransLEStatus, TranCode, CeatedDate, MerchantCode , SettleDate, TranLocalDate)
		values (@AccountLEId, @AvailableBalance, @TranAmount, @TranType, 0, @TranCode, getDate(), '000000000000000', @SettleDate, @TranLocalDate);	
	end
	
	--Start for maintain AvailableBalance for TranLEStatus = 0.
	if exists(select * from AccountLE with(nolock) where AccountNumber = @AccountNumber AND ProgramId = @ProgramId AND ISNULL(FinanceExpireDate, @MaxDay) > @yesterday )
	begin
		update le
		set le.BalanceAvailable = a.BalanceAvailable, le.LEInitBalance = a.BalanceAvailable
		from AccountLE le with(nolock) inner join Account a with(nolock) on le.AccountNumber = a.AccountNumber AND le.ProgramId = a.ProgramId
		where le.Id = @AccountLEId
	end
	--End for maintain AvailableBalance for TranLEStatus = 0.
	
	
	--Vouchers which can generate L&E transactions, must have very big ActiveTo date. It means no expiry date. 
	--Meanwhile, FinanceExpireDate must be less than today.
	if (ISNULL(@FinanceExpireDate, @MaxDay)) <= GETUTCDATE() AND (@AccountActiveTo > @MaxDay)
	begin
		--Redemption PreAuthorizationComplete TrashMoney TrashNoMoney
		IF (@TranType = 101 OR @TranType = 103 OR @TranType = 404 OR @TranType = 405)
		BEGIN
			insert into AccountLETrans (AccountLEId, TranBalanceAvailable, TranAmount, TranType, TransLEStatus, TranCode, CeatedDate, MerchantCode , SettleDate, TranLocalDate)
			values (@AccountLEId, @AvailableBalance, @TranAmount, @TranType, 3, @TranCode, getDate(), '000000000000000', @SettleDate, @TranLocalDate);	  
		END

		IF (@TranType = 201 OR @TranType = 203 OR @TranType = 402)
		BEGIN
			insert into AccountLETrans (AccountLEId, TranBalanceAvailable, TranAmount, TranType, TransLEStatus, TranCode, CeatedDate, MerchantCode , SettleDate, TranLocalDate)
			values (@AccountLEId, @AvailableBalance, @TranAmount, @TranType, 1, @TranCode, getDate(), '000000000000000', @SettleDate, @TranLocalDate);		
		END
	end
	else
	begin
		IF (@TranType = 404 OR @TranType = 405)
		BEGIN
			 if exists (select * from AccountLE with(nolock) where Id = @AccountLEId)
			 begin
				--update les
				--set les.TransLEStatus = 2
				--from AccountLE le with(nolock) 
				--inner join AccountLETrans les with(nolock) on le.Id = les.AccountLEId
				--where les.TranType = 402 AND le.AccountNumber = @AccountNumber AND le.ProgramId = @ProgramId;

				update AccountLETrans set TransLEStatus = 2 where TranType = 402 and AccountLEId = @AccountLEId
			 end
		END	
	end
END;
