
-- =============================================
-- Author:		<eawang>
-- Create date: <2016-12-28>
-- Description:	<update shops' security key to be the same as merchant's security key>
-- =============================================
CREATE PROCEDURE [dbo].[spSyncShopSecurityKeyWithMerchant]
	@MerchantId INT
AS 
BEGIN
	SET NOCOUNT ON;

	UPDATE s
	set s.SecurityKey = m.SecurityKey
	FROM [Shop] s join [Merchant] m on s.merchantid = m.id
	WHERE m.Id = @MerchantId and m.SameKeyWithShop = 1
	
END

