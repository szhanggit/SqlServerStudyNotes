CREATE PROCEDURE [product].[sp_sel_product_by_id]

	-- Add the parameters for the stored procedure here
	@ProductId int
AS
begin 
select	tp.[product_id] as ProductId,
		tp.[product_code] as ProductCode,
		tp.[external_product_code] as ExternalProductCode,
		tp.[brand_id] as BrandId,
		tp.[sku_id] as SkuId,
		tp.[product_name] as ProductName,
		tp.[description] as Description,
		tp.[product_type] as ProductType,
		tp.[product_base_type] as ProductBaseType,
		tp.[multiple_selection_type] as MultipleSelectionType,
		tp.[redeem_time] as RedeemTime,
		tp.[can_topup] as CanTopup,
		tp.[is_master] as IsMaster,
		tp.[is_dynamic] as IsDynamic,
		tp.[is_deferred_child] as IsDeferredChild,
		tp.[is_cart_version] as IsCartVersion,
		tp.[status] as Status,
		tp.[can_issue] as CanIssue,
		tp.[stop_issue_time] as StopIssueTime,
		tp.[reminder_id] as ReminderId,
        tp.[voucher_issuer_id] as VoucherIssuerId,
		tp.[product_category] as ProductCategory,
		tp.[product_tag] as ProductTag,
		tp.[product_issuer] as ProductIssuer,
		tp.[pin_code_type] as PinCodeType,
		tp.[pin_code_length] as PinCodeLength,
		tp.[operation_note] as OperationNote,
		tp.[sales_note] as SalesNote,
		tp.[customer_service_note] as CustomerServiceNote,
	    tp.[can_extend] as CanExtend,
		tp.[extension_scheme_id] as ExtensionSchemeId,
		tp.[max_extend_times] as MaxExtendTimes,
		tp.[extension_end_date] as ExtensionEndDate,
		tp.[same_as_contract_end_date] as SameAsContractEndDate,
		tp.[acceptance_loop_id] as AcceptanceLoopId,
		tp.[issue_merchant] as IssueMerchant
		from [product].[tb_p_product] tp  with(nolock) 
		inner join [product].[tb_p_product_version] tpv with(nolock)  on tp.[product_id] = tpv.[product_id] 
		where tp.[product_id] = @ProductId 
		and tpv.[is_current_version] = 1

end