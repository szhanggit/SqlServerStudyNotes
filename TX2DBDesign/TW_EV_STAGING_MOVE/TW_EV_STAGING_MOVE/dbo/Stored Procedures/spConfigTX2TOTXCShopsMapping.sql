
Create PROCEDURE [dbo].[spConfigTX2TOTXCShopsMapping]
	@DataInput TX2TOTXCShopMappingParameter Readonly,
	@tenantName varchar(50),
	@tenantId int
AS
BEGIN

INSERT INTO dbo.TXCAddressMapping(AddressId,ExternalId,TXCTenantId) SELECT TXAddressConnectionId,ExternalTXCAddressId,@tenantId FROM @DataInput;
INSERT INTO dbo.TXCShopMapping(TX2ShopId,TXCShopId,TenantId) SELECT TXShopConnectionId,ExternalTXCShopId,@tenantId FROM @DataInput;

END
