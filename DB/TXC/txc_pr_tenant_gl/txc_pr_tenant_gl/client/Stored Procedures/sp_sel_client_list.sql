CREATE PROCEDURE [client].[sp_sel_client_list]
	-- Add the parameters for the stored procedure here
    @RowCount int = 20,
	@PageOffset int = 0,
	@SearchKeyWord NVARCHAR(100),
	@ClientId INT = 0,
	@TotalCount int = 0 OUTPUT
AS
BEGIN
	IF(@ClientId > 0)
    BEGIN
                SELECT c.[client_id] AS ClientId,
				c.[client_name] AS ClientName,
				c.[identity_code] AS IdentityCode,
				c.[voucher_issuer_id] AS VoucherIssuerId,
				c.[invoice_register_number] AS InvoiceRegisterNumber,
				c.[business_type_id] AS BusinessTypeId,
				c.[status] ,
				c.[security_algorithm] AS SecurityAlgorithm,
				c.[security_key] AS SecurityKey,
				c.[need_notification] AS NeedNotification,
				c.[notification_provider_code_id] AS NotificationProviderCodeId,
				c.[logo_media_id] AS LogoMediaId,
				c.[banner_media_id] AS BannerMediaId,
				c.[email_header_media_id] AS EmailHeaderMediaId,
				c.[email_footer_media_id] AS EmailFooterMediaId,
				c.[can_issue] AS CanIssue,
				c.[mandatory_auto_billing] AS MandatoryAutoBilling,
				c.[invoice_title] AS InvoiceTitle,
				c.[sub_url] AS SubURL,
				c.[email_provider_code] AS EmailProviderCode,
				c.[email_sender_name] AS EmailSenderName,
				c.[email_sender_address] AS EmailSenderAddress,
				c.[apply_email_subject] AS ApplyEmailSubject,
				c.[sms_provider_code] AS SMSProviderCode,
				c.[sms_sender_name] AS SMSSenderName,
				c.[sms_entity_id] AS SMSEntityId,
				c.[sales_email] AS SalesEmail,
				c.[contact_name] AS ContactName,
				c.[contact_email] AS ContactEmail,
				c.[contact_phone] AS ContactPhone,
				c.[Memo],
                c.[description] AS [Description],
				addre.detail_address_line as DetailAddressLine, 
				addre.district as District, 
				addre.city_id as CityId, 
				addre.state_province_id as StateOrProvinceId, 
				addre.postcode as Postcode, 
				addre.country_id as CountryId, 
				addre.longitude as Longitude, 
				addre.latitude as Latitude, 
				addre.[Status] as AddressStatus
			FROM [client].[tb_cbi_client_basic_information] c with(nolock)
			inner join [general].[tb_a_address] addre with(nolock) on c.address_id = addre.address_id
			where c.client_id = @ClientId;

        SET @TotalCount = 1;
    END
    ELSE
    BEGIN
        create table #Tmp 
        (
            ID int NOT NULL
        );
        
        INSERT INTO #Tmp SElECT client_id FROM
        (
        SElECT client_id from tb_cbi_client_basic_information c with(nolock) where c.client_name LIKE N'%'+@SearchKeyWord+'%'
        Union
        SElECT client_id from tb_cbi_client_basic_information c with(nolock) where c.invoice_register_number LIKE N'%'+@SearchKeyWord+'%'
        ) CL

       SELECT c.[client_id] AS ClientId,
				c.[client_name] AS ClientName,
				c.[identity_code] AS IdentityCode,
				c.[voucher_issuer_id] AS VoucherIssuerId,
				c.[invoice_register_number] AS InvoiceRegisterNumber,
				c.[business_type_id] AS BusinessTypeId,
				c.[status] ,
				c.[security_algorithm] AS SecurityAlgorithm,
				c.[security_key] AS SecurityKey,
				c.[need_notification] AS NeedNotification,
				c.[notification_provider_code_id] AS NotificationProviderCodeId,
				c.[logo_media_id] AS LogoMediaId,
				c.[banner_media_id] AS BannerMediaId,
				c.[email_header_media_id] AS EmailHeaderMediaId,
				c.[email_footer_media_id] AS EmailFooterMediaId,
				c.[can_issue] AS CanIssue,
				c.[mandatory_auto_billing] AS MandatoryAutoBilling,
				c.[invoice_title] AS InvoiceTitle,
				c.[sub_url] AS SubURL,
				c.[email_provider_code] AS EmailProviderCode,
				c.[email_sender_name] AS EmailSenderName,
				c.[email_sender_address] AS EmailSenderAddress,
				c.[apply_email_subject] AS ApplyEmailSubject,
				c.[sms_provider_code] AS SMSProviderCode,
				c.[sms_sender_name] AS SMSSenderName,
				c.[sms_entity_id] AS SMSEntityId,
				c.[sales_email] AS SalesEmail,
				c.[contact_name] AS ContactName,
				c.[contact_email] AS ContactEmail,
				c.[contact_phone] AS ContactPhone,
				c.[Memo],                
                c.[description] AS [Description],
				addre.detail_address_line as DetailAddressLine, 
				addre.district as District, 
				addre.city_id as CityId, 
				addre.state_province_id as StateOrProvinceId, 
				addre.postcode as Postcode, 
				addre.country_id as CountryId, 
				addre.longitude as Longitude, 
				addre.latitude as Latitude, 
				addre.[Status] as AddressStatus
        FROM #Tmp t with(nolock) 
        INNER JOIN [client].[tb_cbi_client_basic_information] c with(nolock) on t.Id = c.client_id
		INNER JOIN [general].[tb_a_address] addre with(nolock) on c.address_id = addre.address_id
        Order BY c.client_id 
        OFFSET @PageOffset ROWS
	    FETCH NEXT @RowCount ROWS ONLY

        SELECT @TotalCount = count(1) FROM #Tmp;
        
        DROP TABLE #Tmp
    END
	
END