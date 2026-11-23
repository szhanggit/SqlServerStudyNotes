
Create PROCEDURE [dbo].[spConfigTX2TOTXCMerchantsMapping]
	@DataInput TX2TOTXCMerchantMappingParameter Readonly,
	@tenantName varchar(50),
	@tenantId int
AS
BEGIN

INSERT INTO dbo.TXCAddressMapping(AddressId,ExternalId,TXCTenantId) SELECT TXAddressConnectionId,ExternalTXCAddressId,@tenantId FROM @DataInput;
INSERT INTO dbo.TXCMerchantMapping(TX2MerchantId,TXCMerchantId,TenantId) SELECT TXMerchantConnectionId,ExternalTXCMerchantId,@tenantId FROM @DataInput;

END
