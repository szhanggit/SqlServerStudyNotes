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
	  if(exists(select 1 from Voucher v join Product p on v.ProductId = p.Id
	                 join Program pg on v.ProgramId = pg.id
					 join AcceptanceLoop al on p.AcceptanceLoopId = al.id
					 join AcceptanceLoopMerchant alm on al.id = alm.AcceptanceLoopId
					 Join Merchant m on alm.MerchantId = m.id
					 left join AcceptanceLoopShop als on als.AcceptanceLoopMerchantId = alm.id
					 left join Shop s on als.ShopId=s.id
                where m.IdentityCode = @MerchantCode and (rtrim(ltrim(isnull(@ShopCode,'')))='' or s.IdentityCode=@ShopCode)
				      and pg.IdentityCode = @ProgramCode 
					  and v.VoucherNumber = @VoucherNumber
			 ))
	     select @Ret = 1
	  else
	     select @Ret = 0
END

