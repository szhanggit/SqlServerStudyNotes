Create   PROCEDURE [dbo].[spTX2TOTXCShopMapping]
@SelectedTable TableTX2TOTXCMappingType READONLY
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT st.TenantId, st.Id AS TXCShopId, s.Id AS TX2ShopId, s.AddressId AS TX2AddressId, s.MerchantId AS TX2MerchantId
    FROM @SelectedTable st 
	INNER JOIN dbo.TXCShopMapping tm with(nolock) ON st.Id = tm.TXCShopId AND st.TenantId = tm.TenantId
	INNER JOIN dbo.Shop s with(nolock) ON tm.TX2ShopId = s.Id	
END;