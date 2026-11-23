CREATE PROCEDURE [product].[sp_sel_product_by_version_id]
@ProductVersionId INT
AS
BEGIN

	SELECT
		p.product_id ProductId,
		p.product_code ProductCode,
		pv.external_product_code ExternalProductCode,
		pv.brand_id BrandId,
		pv.sku_id SkuId,
		pv.product_name ProductName,
		pv.description Description,
		p.product_type ProductType,
		p.product_base_type ProductBaseType,
		p.multiple_selection_type MultipleSelectionType,
		p.redeem_time RedeemTime,
		p.can_topup CanTopup,
		p.is_master IsMaster,
		p.is_dynamic IsDynamic,
		p.is_deferred_child IsDeferredChild,
		p.is_cart_version IsCartVersion,
		p.status Status,
		p.can_issue CanIssue,
		p.stop_issue_time StopIssueTime,
		pv.reminder_id ReminderId,
		pv.voucher_issuer_id VoucherIssuerId,
		pv.product_category ProductCategory,
		pv.product_tag ProductTag,
		pv.product_issuer ProductIssuer,
		pv.pin_code_type PinCodeType,
		pv.pin_code_length PinCodeLength,
		pv.operation_note OperationNote,
		pv.sales_note SalesNote,
		pv.customer_service_note CustomerServiceNote,
		pv.can_extend CanExtend,
		pv.extension_scheme_id ExtensionSchemeId,
		pv.max_extend_times MaxExtendTimes,
		pv.extension_end_date ExtensionEndDate,
		pv.same_as_contract_end_date SameAsContractEndDate,
		pv.acceptance_loop_id AcceptanceLoopId,
		pv.issue_merchant IssueMerchant
	FROM product.tb_p_product p
	INNER JOIN product.tb_p_product_version pv ON p.product_id = pv.product_id
	WHERE pv.product_version_id = @ProductVersionId

END