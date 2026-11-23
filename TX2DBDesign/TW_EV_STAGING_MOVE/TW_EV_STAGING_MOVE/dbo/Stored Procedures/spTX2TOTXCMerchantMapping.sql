Create   PROCEDURE [dbo].[spTX2TOTXCMerchantMapping]
@SelectedTable TableTX2TOTXCMappingType READONLY
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT st.TenantId, st.Id AS TXCMerchantId,m.Id AS TX2MerchantId,m.AddressId AS TX2AddressId,m.ProgramId AS TX2ProgramId
    FROM @SelectedTable st 
	INNER JOIN dbo.TXCMerchantMapping tm with(nolock) ON st.Id = tm.TXCMerchantId AND st.TenantId = tm.TenantId
	INNER JOIN dbo.Merchant m with(nolock) ON tm.TX2MerchantId = m.Id	
END;