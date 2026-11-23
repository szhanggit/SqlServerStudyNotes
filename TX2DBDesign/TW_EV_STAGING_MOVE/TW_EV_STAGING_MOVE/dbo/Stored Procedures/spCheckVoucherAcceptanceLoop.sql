-- =============================================
-- Author:		Knight YAO
-- Create date: 2015/09/06
-- Description:	Assign voucher.
-- =============================================
CREATE PROCEDURE [dbo].[spCheckVoucherAcceptanceLoop]
	@VoucherNumber		varchar(50),
	@ProgramCode		varchar(20),
	@MerchantCode		varchar(50),
	@ShopCode			varchar(50) = null,
	@Ret                BIT		OUTPUT
AS
BEGIN
	SET @ret = 0

	IF len(isnull(@ShopCode,'')) = 0
	BEGIN
		if(exists(select 1 from Voucher v with(NOLOCK) join Product p with(NOLOCK) on v.ProductId = p.Id
	                 join Program pg with(NOLOCK) on v.ProgramId = pg.id
					 join AcceptanceLoop al with(NOLOCK) on p.AcceptanceLoopId = al.id
					 join AcceptanceLoopMerchant alm with(NOLOCK) on al.id = alm.AcceptanceLoopId
					 Join Merchant m with(NOLOCK) on alm.MerchantId = m.id
          where m.IdentityCode = @MerchantCode
				      and pg.IdentityCode = @ProgramCode 
					    and v.VoucherNumber = @VoucherNumber
			 ))
	     SET @Ret = 1
	END
	ELSE
	BEGIN
		if(exists(select 1 from Voucher v with(NOLOCK) join Product p with(NOLOCK) on v.ProductId = p.Id
	                 join Program pg with(NOLOCK) on v.ProgramId = pg.id
					 join AcceptanceLoop al with(NOLOCK) on p.AcceptanceLoopId = al.id
					 join AcceptanceLoopMerchant alm with(NOLOCK) on al.id = alm.AcceptanceLoopId
					 Join Merchant m with(NOLOCK) on alm.MerchantId = m.id
					 Join AcceptanceLoopShop als with(NOLOCK) on als.AcceptanceLoopMerchantId = alm.id
					 Join Shop s with(NOLOCK) on als.ShopId=s.id
          where m.IdentityCode = @MerchantCode and s.IdentityCode= @ShopCode
				      and pg.IdentityCode = @ProgramCode 
					    and v.VoucherNumber = @VoucherNumber
			 ))
	     SET @Ret = 1
	END
END