CREATE PROCEDURE [dbo].[sp_publish_order_fail_list]
AS
BEGIN

	-- 32 OrderStatus.Publishing
	-- 1 OrderExecutingStatus.NotStart
	-- 2 OrderExecutingStatus.AssignVoucher

	SELECT [id] "Id"
		,[quotation_id] "QuotationId"
		,[order_number] "OrderNumber"
		,[mode] "Mode"
		,[is_direct_delivery] "IsDirectDelivery"
		,[publish_datetime] "PublishDateTime"
		,[status] "Status"
		,[executing_status] "ExecutingStatus"
		,[executing_response] "ExecutingResponse"
		,[created_by] "CreatedBy"
		,[created_on] "CreatedOn"
		,[package_receiver] "PackageReceiver"
		,[package_password] "PackagePassword"
		,[package_pin_receiver] "PackagePinReceiver"
		,[order_name] "OrderName"
		,[short_url_auth_code_generation_way] "ShortUrlAuthCodeGenerationWay"
		,[order_group_id] "OrderGroupId"
		,[indirect_file_format] "IndirectFileFormat"
		,[export_barcode_info] "ExportBarcodeInfo"
		,[voucher_supplier_id] "VoucherSupplierId"
		,[voucher_supplier_order_number] "VoucherSupplierOrderNumber"
		,[voucher_supplier_quotation_number] "VoucherSupplierQuotationNumber"
		,[email_attach_short_url_image_id] "EmailAttachShortUrlImageId"
		,[url_type] "UrlType"
		,[generate_sequence_number] "GenerateSequenceNumber"
		,[memo] "Memo"
		,[needed_preIssue] "NeededPreIssue"
		,[wallet_slms_template_id] "WalletSlmsTemplateId"
		,[email_template_id] "EmailTemplateId"
		,[slms_template_id] "SlmsTemplateId"
		,[MWV_email_template_id] "MWVEmailTemplateId"
		,[updated_by] "UpdatedBy"
		,[updated_on] "UpdatedOn"
		,[email_tag_value_set_id] "EmailTagValueSetId"
		,[slms_tag_value_set_id] "SlmsTagValueSetId"
	FROM [dbo].[tb_ob_order_basic]
	WHERE [Status] = 32 AND ([executing_status] = 1 OR [executing_status] = 2)

END