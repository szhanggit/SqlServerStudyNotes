
CREATE PROCEDURE [dbo].[spProcessOldLE]
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @num int;
	DECLARE @dateStart datetime
	SET @dateStart = CONVERT(nvarchar(10), DATEADD(DAY, -14, GETDATE()), 111)
	SET @dateStart = CONVERT(NVARCHAR(10), @dateStart, 111)

	CREATE TABLE #TempAccount (
		[Id]				INT IDENTITY (1, 1) NOT NULL,
		[VoucherNumber]		VARCHAR (50) NULL,
		[ProgramId]			INT          NULL,
		[IdentityCode]		VARCHAR (50) NULL,
		[AdoraProgramId]    INT NULL
	);

	insert into #TempAccount ([VoucherNumber], [ProgramId], [IdentityCode])
	select v.VoucherNumber, p.ProgramId, program.IdentityCode 
	from [TW_EV_UAT_MOVE].dbo.Voucher v WITH(nolock)
	join [TW_EV_UAT_MOVE].dbo.OrderBeneficiaryInfo obi WITH(nolock) on obi.Id = v.BeneficiaryInfoId
	join [TW_EV_UAT_MOVE].dbo.OrderLine ol WITH(nolock) on ol.Id = obi.OrderLineId
	join [TW_EV_UAT_MOVE].dbo.[Order] o WITH(NOLOCK) ON o.Id = ol.OrderId
	JOIN [TW_EV_UAT_MOVE].dbo.ClientQuotationProduct cqp WITH(nolock) ON ol.ClientQuotationProductId = cqp.Id
	JOIN [TW_EV_UAT_MOVE].dbo.ClientQuotation cq WITH(NOLOCK) ON cqp.ClientQuotationId = cq.Id
	JOIN [TW_EV_UAT_MOVE].dbo.ProductVersion pv WITH(NOLOCK) ON cqp.ProductVersionId = pv.Id
	JOIN [TW_EV_UAT_MOVE].dbo.Product p WITH(NOLOCK) ON p.Id = pv.ProductId
	JOIN [TW_EV_UAT_MOVE].dbo.Program program with(nolock) ON p.ProgramId = program.Id
	left join AccountLE le with(nolock) on le.AccountNumber = v.VoucherNumber AND le.ProgramCode = program.IdentityCode
	where o.[Status] = 64 AND cq.BusinessModelId in (1,2,3,8) AND p.ProductIssuerType = 0 AND v.ActivatedOn > @dateStart
	AND le.AccountNumber is null AND v.ExpiryDate >= '21500101'

	update aa
	set aa.AdoraProgramId = p.Id
	from #TempAccount aa with(nolock)
	inner join Program p with(nolock) on aa.IdentityCode = p.IdentityCode

	select @num = count(*) from #TempAccount with(nolock);
	select @num;
	if @num > 0
	begin
		insert into AccountLE (ProgramId, ProgramCode, AccountNumber, BalanceAvailable, [FinanceExpireDays], [FinanceExpireDate], LEStatus, InitBalance, LEInitBalance)
		select a.ProgramId, aa.IdentityCode as ProgramCode, a.AccountNumber, a.BalanceInitialized,
		364 as [FinanceExpireDays], DATEADD(DAY,364,CONVERT(NVARCHAR(10), a.ActivatedOn, 120) + ' 15:59:59') as [FinanceExpireDate], 0 as LEStatus, a.BalanceInitialized as InitBalance,
		a.BalanceInitialized as LEInitBalance
		from #TempAccount aa with(nolock)
		inner join account a with(nolock) on aa.AdoraProgramId = a.ProgramId AND aa.VoucherNumber = a.AccountNumber


		update le
		set le.LEInitBalance = a.BalanceAvailable
		from AccountLE le with(nolock)
		inner join #TempAccount aa with(nolock) on le.AccountNumber = aa.VoucherNumber AND le.ProgramId = aa.AdoraProgramId
		inner join Account a with(nolock) on le.AccountNumber = a.AccountNumber AND le.ProgramId = a.ProgramId
		left join AccountLETrans let with(nolock) on le.Id = let.AccountLEId
		where let.TranType is null and DATEDIFF(year, GETUTCDATE(), a.ActiveTo) > 100 and le.FinanceExpireDays = 364
		AND le.FinanceExpireDate > getutcdate()

		insert into AccountLETrans(AccountLEId, TranBalanceAvailable, TranAmount, TransLEStatus, TranType, TranCode, MerchantCode, SettleDate, TranLocalDate, CeatedDate)
		select le.Id as AccountLEId, a.BalanceInitialized as TranBalanceAvailable,
		a.BalanceAvailable as TranAmount, 0 as TransLEStatus, 402 as TranType, th.TranCode as TranCode, a.ConsumeMerchantCode as MerchantCode, null as SettleDate,
		th.TranLocalDate as TranLocalDate, GETDATE() as CeatedDate
		from AccountLE le with(nolock)
		inner join #TempAccount temp with(nolock) on le.AccountNumber = temp.VoucherNumber AND le.ProgramId = temp.AdoraProgramId
		inner join TransactionHistory th with(nolock) on le.AccountNumber = th.AccountNumber AND th.TranType = 402 AND ResponseCode = '0000'
		inner join Account a with(nolock) on le.AccountNumber = a.AccountNumber AND le.ProgramId = a.ProgramId
		left join AccountLETrans let with(nolock) on le.Id = let.AccountLEId
		where let.TranType is null and DATEDIFF(year, GETUTCDATE(), a.ActiveTo) > 100 and le.FinanceExpireDays = 364 
		
	 
	 
		insert into AccountLETrans(AccountLEId, TranBalanceAvailable, TranAmount, TransLEStatus, TranType, TranCode, MerchantCode, SettleDate, TranLocalDate, CeatedDate)
		select le.Id as AccountLEId, a.BalanceInitialized as TranBalanceAvailable,
		a.BalanceAvailable as TranAmount, 0 as TransLEStatus, 402 as TranType, th.TranCode as TranCode, a.ConsumeMerchantCode as MerchantCode, null as SettleDate,
		th.TranLocalDate as TranLocalDate, GETDATE() as CeatedDate
		from AccountLE le with(nolock)
		inner join #TempAccount temp with(nolock) on le.AccountNumber = temp.VoucherNumber AND le.ProgramId = temp.AdoraProgramId
		inner join [Transaction] th with(nolock) on le.AccountNumber = th.AccountNumber AND th.TranType = 402 AND ResponseCode = '0000'
		inner join Account a with(nolock) on le.AccountNumber = a.AccountNumber AND le.ProgramId = a.ProgramId
		left join AccountLETrans let with(nolock) on le.Id = let.AccountLEId
		where let.TranType is null and DATEDIFF(year, GETUTCDATE(), a.ActiveTo) > 100 and le.FinanceExpireDays = 364
 
	end

END;
