
Create PROCEDURE [merchant_info].[sptranferTXShops]
	@DataInputShop [merchant_info].sourceShopParameter Readonly,
	@DataInputAddress [merchant_info].sourceShopAddressParameter Readonly
AS
BEGIN

DECLARE @MapAddress AS TABLE
(
    TX2AddressId int,
    InsertedAddressId int
)

DECLARE @MapShop AS TABLE
(
    TX2ShopId int,
	TX2AddressId int,
    InsertedId int
)

BEGIN TRANSACTION
BEGIN TRY
BEGIN
	MERGE INTO general.tb_a_address USING @DataInputAddress AS source 
        ON 1 = 0
    WHEN NOT MATCHED THEN
        INSERT 
           ([detail_address_line]
           ,[district]
           ,[city_id]
           ,[state_province_id]
           ,[country_id]
           ,[postcode]
           ,[longitude]
           ,[latitude]
           ,[status])
     VALUES
           (source.detail_address_line
           ,source.district
           ,source.city_id
           ,source.state_province_id
           ,source.country_id
           ,source.postcode
           ,source.longitude
           ,source.latitude
           ,source.status)
        OUTPUT source.Id,inserted.address_id 
        INTO @MapAddress (TX2AddressId, InsertedAddressId);

    MERGE INTO merchant_info.tb_s_shop USING @DataInputShop AS source 
        ON 1 = 0
    WHEN NOT MATCHED THEN
        INSERT 
           ([identity_code]
           ,[name]
           ,[merchant_id]
           ,[address_id]
           ,[external_code]
           ,[contact_name]
           ,[contact_phone]
           ,[security_key]
           ,[status]
           ,[subsidiary_uen]
           ,[subsidiary_name]
           ,[created_on]
           ,[last_modified_on]
           ,[last_modifier]
           ,[work_key_id]
           ,[contact_name2]
           ,[contact_phone2])
     VALUES
           (source.identity_code
           ,source.name
           ,source.merchant_id
           ,source.address_id
           ,source.external_code
           ,source.contact_name
           ,source.contact_phone
           ,source.security_key
           ,source.status
           ,source.subsidiary_uen
           ,source.subsidiary_name
           ,source.created_on
           ,source.last_modified_on
           ,source.last_modifier
           ,source.work_key_id
           ,source.Contact_Name2
           ,source.Contact_Phone2)
        OUTPUT source.Id,source.address_id,inserted.Id 
        INTO @MapShop (TX2ShopId,TX2AddressId, InsertedId);

        UPDATE s SET s.address_id = a.InsertedAddressId from merchant_info.tb_s_shop s INNER JOIN @MapAddress a ON s.address_id = a.TX2AddressId;
	
	  SELECT s.InsertedId as ExternalTXCShopId, s.TX2ShopId as TXShopConnectionId, a.TX2AddressId as TXAddressConnectionId, a.InsertedAddressId as ExternalTXCAddressId
      FROM @MapShop as s INNER JOIN @MapAddress as a on s.TX2AddressId = a.TX2AddressId;
END

COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
	SELECT ERROR_NUMBER(), ERROR_MESSAGE();
END CATCH

END
