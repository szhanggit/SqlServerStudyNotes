CREATE PROCEDURE [order].[sp_publish_order_list]
AS
BEGIN


	-- 512 OrderStatus.ToRepublish
	-- 8 OrderStatus.ApprovedByPM
	-- 16 OrderStatus.ApprovedByFT

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
	FROM [order].[tb_ob_order_basic]
	WHERE [Status] = 512 
	OR ([Status] = 8 OR [Status] = 16)
	AND publish_datetime < GETUTCDATE()
	ORDER BY Id

	-- 8 should also be !o.ClientQuotation.AdvanceBilling but will be in process order job
END