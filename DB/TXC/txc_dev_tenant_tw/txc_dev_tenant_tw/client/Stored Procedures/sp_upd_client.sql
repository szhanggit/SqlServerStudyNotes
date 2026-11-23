CREATE PROCEDURE [client].[sp_upd_client]
         @ClientId int
        ,@ClientName nvarchar(100)
        ,@InvoiceRegisterNumber nvarchar(100)
        ,@VoucherIssuerId int = NULL
        ,@BusinessTypeId int = NULL
        ,@Status tinyint
        ,@SecurityAlgorithm tinyint
        ,@SecurityKey varchar(32)
        ,@NeedNotification bit
        ,@NotificationProviderCodeId int = NULL
        ,@LogoMediaId int = NULL
        ,@BannerMediaId int = NULL
        ,@EmailHeaderMediaId int = NULL
        ,@EmailFooterMediaId int = NULL
        ,@CanIssue bit
        ,@MandatoryAutoBilling bit = NULL
        ,@InvoiceTitle nvarchar(100) = NULL
        ,@SubURL nvarchar(6) = NULL
        ,@EmailProviderCode nvarchar(8) = NULL
        ,@EmailSenderName nvarchar(255) = NULL
        ,@EmailSenderAddress nvarchar(255) = NULL
        ,@ApplyEmailSubject bit = NULL
        ,@SmsProviderCode nvarchar(8) = NULL
        ,@SMSSenderName nvarchar(255) = NULL
        ,@SmsEntityId nvarchar(30) = NULL
        ,@SalesEmail nvarchar(255) = NULL
        ,@ContactName nvarchar(30) = NULL
        ,@ContactEmail nvarchar(255) = NULL
        ,@ContactPhone nvarchar(50) = NULL
        ,@Memo nvarchar(2000) = NULL  
        ,@Description nvarchar(500)  = NULL
		, @DetailAddressLine nvarchar(400) = NULL
		, @District nvarchar(400) = NULL
		, @CityId int = NULL
		, @StateOrProvinceId int = NULL
		, @Postcode nvarchar(20) = NULL
		, @CountryId int = NULL
		, @Longitude float = NULL
		, @Latitude float = NULL
		, @AddressStatus int = NULL
AS
BEGIN
	SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;       
		Declare @AddressId int = NULL;

		UPDATE [client].[tb_cbi_client_basic_information]
		   SET [client_name] = @ClientName
			  ,[voucher_issuer_id] = @VoucherIssuerId
			  ,[invoice_register_number] = @InvoiceRegisterNumber
			  ,[business_type_id] = @BusinessTypeId
			  ,[status] = @Status
			  ,[security_algorithm] = @SecurityAlgorithm
			  ,[security_key] = @SecurityKey
			  ,[need_notification] = @NeedNotification
			  ,[notification_provider_code_id] = @NotificationProviderCodeId
			  ,[logo_media_id] = @LogoMediaId
			  ,[banner_media_id] = @BannerMediaId
			  ,[email_header_media_id] = @EmailHeaderMediaId
			  ,[email_footer_media_id] = @EmailFooterMediaId
			  ,[can_issue] = @CanIssue
			  ,[mandatory_auto_billing] = @MandatoryAutoBilling
			  ,[invoice_title] = @InvoiceTitle
			  ,[sub_url] = @SubURL
			  ,[email_provider_code] = @EmailProviderCode
			  ,[email_sender_name] = @EmailSenderName
			  ,[email_sender_address] = @EmailSenderAddress 
			  ,[apply_email_subject] = @ApplyEmailSubject
			  ,[sms_provider_code] = @SmsProviderCode
			  ,[sms_sender_name] = @SMSSenderName
			  ,[sms_entity_id] = @SmsEntityId
			  ,[sales_email] = @SalesEmail
			  ,[contact_name] = @ContactName
			  ,[contact_email] = @ContactEmail
			  ,[contact_phone] = @ContactPhone
			  ,[Memo] = @Memo
              ,[description] = @Description
		 WHERE client_id = @ClientId;

		 select @AddressId = address_id from [client].[tb_cbi_client_basic_information] with(nolock) where client_id = @ClientId;

		if (@CountryId is not NULL)
		begin
			update [general].[tb_a_address]
				set [detail_address_line] = @DetailAddressLine
				, [district] = @District
				, [city_id] = @CityId
				, [state_province_id] = @StateOrProvinceId
				, [postcode] = @Postcode
				, [country_id] = @CountryId
				, [longitude] = @Longitude
				, [Latitude] = @Latitude
				, [Status] = @AddressStatus
			where address_id = @AddressId
		end

        COMMIT TRANSACTION;
	
		SELECT @@ROWCOUNT;
    END TRY
    BEGIN CATCH 

       IF @@TRANCOUNT  > 0
       BEGIN
          ROLLBACK TRANSACTION
       END;

	   THROW;
    END CATCH;

    SET NOCOUNT, XACT_ABORT OFF;
END