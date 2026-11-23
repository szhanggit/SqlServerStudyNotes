
Create PROCEDURE [merchant_info].[sptranferTXMerchants]
	@DataInputMerchant [merchant_info].sourceMerchantNewParameter Readonly,
	@DataInputAddress [merchant_info].sourceMerchantAddressParameter Readonly
AS
BEGIN

DECLARE @MapAddress AS TABLE
(
    TX2AddressId int,
    InsertedAddressId int
)

DECLARE @MapMerchant AS TABLE
(
    TX2MerchantId int,
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

    MERGE INTO merchant_info.tb_m_merchant USING @DataInputMerchant AS source 
        ON 1 = 0
    WHEN NOT MATCHED THEN
        INSERT 
           ([program_id]
           ,[address_id]
           ,[identity_code]
           ,[name]
           ,[external_code]
           ,[invoice_register_number]
           ,[security_key]
           ,[status]
           ,[tx1_merchant_uid]
           ,[is_auto_create_reimbursement]
           ,[auto_create_reimbursement_interval_type]
           ,[reimbursement_tax_type]
           ,[reimbursement_type]
           ,[reimbursement_receivers]
           ,[same_key_with_shop]
           ,[mam_email]
           ,[merchant_auto_type]
           ,[notification_merchant_code]
           ,[merchant_email]
           ,[merchant_acquire_id]
           ,[need_consumer_scan]
           ,[memo]
           ,[issuer_type]
           ,[modifier]
           ,[version]
           ,[version_time]
           ,[work_key_id]
           ,[is_legacy_merchant]
           ,[main_contact]
           ,[main_phone]
           ,[auto_create_reimbursement_day]
           ,[category_Id]
           ,[Description])
     VALUES
           (source.program_id
           ,source.address_id
           ,source.identity_code
           ,source.name
           ,source.external_code
           ,source.invoice_register_number
           ,source.security_key
           ,source.status
           ,source.tx1_merchant_uid
           ,source.is_auto_create_reimbursement
           ,source.auto_create_reimbursement_interval_type
           ,source.reimbursement_tax_type
           ,source.reimbursement_type
           ,source.reimbursement_receivers
           ,source.same_key_with_shop
           ,source.mam_email
           ,source.merchant_auto_type
           ,source.notification_merchant_code
           ,source.merchant_email
           ,source.merchant_acquire_id
           ,source.need_consumer_scan
           ,source.memo
           ,source.issuer_type
           ,source.modifier
           ,source.version
           ,source.version_time
           ,source.work_key_id
           ,source.is_legacy_merchant
           ,source.main_contact
           ,source.main_phone
           ,source.auto_create_reimbursement_day
           ,source.category_Id
           ,source.Description)
        OUTPUT source.Id,source.address_id,inserted.Id 
        INTO @MapMerchant (TX2MerchantId,TX2AddressId, InsertedId);

        UPDATE m SET m.address_id = a.InsertedAddressId from merchant_info.tb_m_merchant m INNER JOIN @MapAddress a ON m.address_id = a.TX2AddressId;
	
	  SELECT M.InsertedId as ExternalTXCMerchantId, M.TX2MerchantId as TXMerchantConnectionId, a.TX2AddressId as TXAddressConnectionId, a.InsertedAddressId as ExternalTXCAddressId 
      FROM @MapMerchant as M INNER JOIN @MapAddress as a on m.TX2AddressId = a.TX2AddressId;
END

COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
	SELECT ERROR_NUMBER(), ERROR_MESSAGE();
END CATCH

END
