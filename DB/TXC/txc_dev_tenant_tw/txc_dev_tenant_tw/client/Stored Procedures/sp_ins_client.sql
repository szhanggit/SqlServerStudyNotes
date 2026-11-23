CREATE PROCEDURE [client].[sp_ins_client]
	    @ClientName nvarchar(100)
        ,@IdentityCode varchar(50)
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
        ,@Memo nvarchar(2000)  = NULL
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
	    , @ClientId int output
AS
BEGIN
	SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;
        
		Declare @AddressId int = NULL;

		if (@CountryId is not NULL)
		begin
			insert into [general].[tb_a_address]( 
				[detail_address_line]
				, [district]
				, [city_id]
				, [state_province_id]
				, [postcode]
				, [country_id]
				, [longitude]
				, [latitude]
				, [Status]) values (
				@DetailAddressLine
				, @District
				, @CityId
				, @StateOrProvinceId
				, @Postcode
				, @CountryId
				, @Longitude
				, @Latitude
				, @AddressStatus
				);
			set @AddressId = SCOPE_IDENTITY();
		end

		INSERT INTO [client].[tb_cbi_client_basic_information]
            ([client_name]
            ,[identity_code]
            ,[voucher_issuer_id]
            ,[invoice_register_number]
            ,[business_type_id]
            ,[status]
            ,[security_algorithm]
            ,[security_key]
            ,[need_notification]
            ,[notification_provider_code_id]
            ,[logo_media_id]
            ,[banner_media_id]
            ,[email_header_media_id]
            ,[email_footer_media_id]
            ,[can_issue]
            ,[mandatory_auto_billing]
            ,[invoice_title]
            ,[sub_url]
            ,[email_provider_code]
            ,[email_sender_name]
            ,[email_sender_address]
            ,[apply_email_subject]
            ,[sms_provider_code]
            ,[sms_sender_name]
            ,[sms_entity_id]
            ,[sales_email]
            ,[contact_name]
            ,[contact_email]
            ,[contact_phone]
            ,[Memo]
            ,[description]
			,[address_id])
     VALUES
            (@ClientName 
            ,@IdentityCode 
	        ,@VoucherIssuerId 
	        ,@InvoiceRegisterNumber 
            ,@BusinessTypeId 
            ,@Status 
            ,@SecurityAlgorithm 
            ,@SecurityKey 
            ,@NeedNotification 
            ,@NotificationProviderCodeId 
            ,@LogoMediaId 
	        ,@BannerMediaId 
	        ,@EmailHeaderMediaId 
            ,@EmailFooterMediaId 
	        ,@CanIssue 
            ,@MandatoryAutoBilling 
            ,@InvoiceTitle 
            ,@SubURL 
	        ,@EmailProviderCode 
            ,@EmailSenderName 
            ,@EmailSenderAddress 
	        ,@ApplyEmailSubject 
	        ,@SmsProviderCode 
            ,@SMSSenderName 
            ,@SmsEntityId 
            ,@SalesEmail 
            ,@ContactName 
            ,@ContactEmail 
            ,@ContactPhone 
            ,@Memo
            ,@Description
			,@AddressId)

        COMMIT TRANSACTION;

	set @ClientId = SCOPE_IDENTITY();
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