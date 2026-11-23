-- =============================================
-- Author:		Knight Yao
-- Create date: 2016/07/21
-- Description:	Get Account To Sync
-- =============================================
CREATE PROCEDURE spGetMerchantAndShopNameByCode
	 @MerchantCode varchar(20)
	,@ShopCode   varchar(20) = NULL
	,@ProgramCode varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Select top 1 m.IdentityCode as MerchantCode,
	       m.Name as MerchantName,
		   case when isnull(@ShopCode,'')='' then '' else s.IdentityCode end as ShopCode,
		   case when isnull(@ShopCode,'')='' then '' else s.Name end as ShopName
	From Merchant m with(nolock) left join Shop s with(nolock) on s.Merchantid = m.id
	     join Program p with(nolock) on m.ProgramId = p.id
	where   m.IdentityCode = @MerchantCode
	   and (isnull(@ShopCode,'')='' or s.IdentityCode = @ShopCode)
	   and  p.IdentityCode = @ProgramCode

END
