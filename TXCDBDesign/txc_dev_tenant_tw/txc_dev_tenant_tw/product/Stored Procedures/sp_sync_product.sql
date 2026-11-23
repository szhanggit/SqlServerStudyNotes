CREATE PROCEDURE product.sp_sync_product
@sync_period_from datetime,
@sync_period_to datetime
AS
BEGIN
	DECLARE @T TABLE
	(
		TXCProductId INT,
		TXCProductVersionId INT,
		TXCProgramId INT,
		ProductCode VARCHAR(50),
		ExternalProductCode VARCHAR(50),
		ProductName NVARCHAR(200),
		Description NVARCHAR(500),
		Note NVARCHAR(MAX),
		VoucherNumberGenerateWay TINYINT,
		TXCVoucherNumberRuleId INT,
		ProductType TINYINT,
		CanTopup BIT,
		MinRedeemQuantity INT,
		MaxIssuingQuantity INT,
		ValidFrom DATETIME,
		ValidTo DATETIME,
		ReverseLimitId INT,
		PreAuthorizationExpiryInterval INT,
		PreAuthorizationExpiryUnit TINYINT,
		UseTimeControl SMALLINT,
		UseTimeControlInterval SMALLINT,
		MaxTotalRedeemAmountControl INT,
		MaxTotalRedeemAmountControlInterval SMALLINT,
		MaxSingleRedeemAmount INT,
		Status TINYINT,
		ExpirationDate DATETIME,
		BrandStory NVARCHAR(500),
		CanIssue BIT,
		StopIssueTime DATETIME,
		ReminderId INT,
		MultipleSelectionType TINYINT,
		ProductIssuerType TINYINT,
		TXCIssueMerchant INT,
		PinCodeType TINYINT,
		PinCodeLength TINYINT,
		IsMasterProduct BIT,
		MerchantAcquirerId INT,
		ProductTag INT,
		AddToWallet BIT,
		ProductSubType INT,
		TXCBrandId INT,
		Memo NVARCHAR(2000),
		WalletStatus INT,
		TXCWalletImage INT,
		ProductCategory INT,
		IsDeferredChild BIT,
		CanExtend BIT,
		ExtensionSchemeId INT,
		MaxExtendTimes INT,
		ExtensionEndDate DATETIME,
		SameAsValidEndDateOnContract BIT,
		CreatedBy NVARCHAR(50),
		CreatedOn DATETIME,
		Modifier NVARCHAR(50),
		Version INT,
		VersionTime DATETIME,
		IsCurrentVersion BIT,
		TXCProductTemplateId INT,
		TXCProductPriceId INT,
		TXCProductExpirySchemeId INT,
		TXCProductRedeemDateBlacklistId INT,
		TXCProductRedeemTimeRestrictionId INT,
		TXCProductExternalPropertyId INT,
		TXCProductAcceptanceLoopId INT,
		TXCProductSKUId INT,
		ShowCodeType VARCHAR(20),
		DisplayText BIT,
		IsFixedExpiryPolicy BIT,
		HasMultiBarcode BIT,
		RequireExpiryDate BIT
	)
	
	INSERT INTO @T
	SELECT
		pv.product_id TXCProductId,
		pv.product_version_id TXCProductVersionId,
		p.program_id TXCProgramId,
		p.product_code ProductCode,
		pv.external_product_code ExternalProductCode,
		pv.product_name ProductName,
		pv.description Description,
		pv.operation_note Note,
		r.voucher_generate_way VoucherNumberGenerateWay,
		r.id TXCVoucherNumberRuleId,
		p.product_base_type ProductType,
		p.can_topup CanTopup,
		pv.min_redeem_quantity MinRedeemQuantity,
		pv.max_issuing_quantity MaxIssuingQuantity,
		pv.valid_from ValidFrom,
		pv.valid_to ValidTo,
		pv.reverse_limit_id ReverseLimitId,
		pv.pre_authorization_expiry_interval PreAuthorizationExpiryInterval,
		pv.pre_authorization_expiry_unit PreAuthorizationExpiryUnit,
		pv.use_time_control UseTimeControl,
		pv.use_time_control_interval UseTimeControlInterval,
		pv.max_total_redeem_amount_control MaxTotalRedeemAmountControl,
		pv.max_total_redeem_amount_control_interval MaxTotalRedeemAmountControlInterval,
		pv.max_single_redeem_amount MaxSingleRedeemAmount,
		p.status Status,
		pv.expiry_date ExpirationDate,
		pv.sales_note BrandStory,
		p.can_issue CanIssue,
		p.stop_issue_time StopIssueTime,
		pv.reminder_id ReminderId,
		p.multiple_selection_type MultipleSelectionType,
		pv.product_issuer ProductIssuerType,
		pv.issue_merchant TXCIssueMerchant,
		--pv.pin_code_type PinCodeType,
		--pv.pin_code_length PinCodeLength,
		CASE r.pin_type WHEN 1 THEN 1 WHEN 2 THEN 1 WHEN 3 THEN 1 WHEN 4 THEN 2 WHEN 5 THEN 2 ELSE 0 END PinCodeType,
		CASE r.pin_type WHEN 1 THEN 4 WHEN 2 THEN 6 WHEN 3 THEN 8 WHEN 4 THEN 4 WHEN 5 THEN 6 ELSE 0 END PinCodeLength,
		p.is_master IsMasterProduct,
		pv.voucher_issuer_id MerchantAcquirerId,
		pv.product_tag ProductTag,
		pv.add_to_wallet AddToWallet,
		p.product_type ProductSubType,
		pv.brand_id TXCBrandId,
		pv.customer_service_note Memo,
		pv.wallet_status WalletStatus,
		pv.wallet_image TXCWalletImage,
		pv.product_category ProductCategory,
		pv.is_deferred_child IsDeferredChild,
		pv.can_extend CanExtend,
		pv.extension_scheme_id ExtensionSchemeId,
		pv.max_extend_times MaxExtendTimes,
		pv.extension_end_date ExtensionEndDate,
		pv.same_as_contract_end_date SameAsValidEndDateOnContract,
		p.created_by CreatedBy,
		p.created_on CreatedOn,
		pv.created_by Modifier,
		pv.version Version,
		ISNULL(pv.last_updated_on, pv.created_on) VersionTime,
		pv.is_current_version IsCurrentVersion,
		CASE WHEN pv.version = 1 THEN pv.template_id ELSE NULL END TXCProductTemplateId,
		CASE WHEN pv.version = 1 THEN pv.price_id ELSE NULL END TXCProductPriceId,
		CASE WHEN pv.version = 1 THEN pv.expiry_scheme_id ELSE NULL END TXCProductExpirySchemeId,
		CASE WHEN pv.version = 1 THEN pv.redeem_date_blacklist_id ELSE NULL END TXCProductRedeemDateBlacklistId,
		CASE WHEN pv.version = 1 THEN pv.redeem_time_restriction_id ELSE NULL END TXCProductRedeemTimeRestrictionId,
		--CASE WHEN pv.version = 1 OR ISNULL(pv.wallet_image, 0) <> 0 THEN pv.external_property_id ELSE NULL END TXCProductExternalPropertyId,
		pv.external_property_id TXCProductExternalPropertyId,
		CASE WHEN pv.version = 1 THEN pv.acceptance_loop_id ELSE NULL END TXCProductAcceptanceLoopId,
		pv.sku_id TXCProductSKUId,
		bt.description, --ShowcodeType
		r.dist_voucher_num_under_barcode, --DisplayText
		pv.is_fixed_expiry_policy,
		r.has_multipart_barcode HasMultiBarcode,
		r.request_expiry_date RequireExpiryDate
	FROM product.tb_p_product p
	INNER JOIN product.tb_p_product_version pv on p.product_id = pv.product_id and pv.is_current_version = 1
	LEFT OUTER JOIN merchant_info.tb_contract_sku s ON pv.sku_id = s.id
	LEFT OUTER JOIN merchant_info.tb_vnr_voucher_number_rule r ON s.voucher_number_rule_id = r.id
	LEFT OUTER JOIN merchant_info.tb_bt_barcode_type bt ON r.barcode_type_id  = bt.id
	WHERE (p.created_on > @sync_period_from AND p.created_on <= @sync_period_to)
	OR (p.last_updated_on > @sync_period_from AND p.last_updated_on <= @sync_period_to)
	
	UNION
	
	SELECT
		pv.product_id TXCProductId,
		pv.product_version_id TXCProductVersionId,
		p.program_id TXCProgramId,
		p.product_code ProductCode,
		pv.external_product_code ExternalProductCode,
		pv.product_name ProductName,
		pv.description Description,
		pv.operation_note Note,
		r.voucher_generate_way VoucherNumberGenerateWay,
		r.id TXCVoucherNumberRuleId,
		p.product_base_type ProductType,
		p.can_topup CanTopup,
		pv.min_redeem_quantity MinRedeemQuantity,
		pv.max_issuing_quantity MaxIssuingQuantity,
		pv.valid_from ValidFrom,
		pv.valid_to ValidTo,
		pv.reverse_limit_id ReverseLimitId,
		pv.pre_authorization_expiry_interval PreAuthorizationExpiryInterval,
		pv.pre_authorization_expiry_unit PreAuthorizationExpiryUnit,
		pv.use_time_control UseTimeControl,
		pv.use_time_control_interval UseTimeControlInterval,
		pv.max_total_redeem_amount_control MaxTotalRedeemAmountControl,
		pv.max_total_redeem_amount_control_interval MaxTotalRedeemAmountControlInterval,
		pv.max_single_redeem_amount MaxSingleRedeemAmount,
		p.status Status,
		pv.expiry_date ExpirationDate,
		pv.sales_note BrandStory,
		p.can_issue CanIssue,
		p.stop_issue_time StopIssueTime,
		pv.reminder_id ReminderId,
		p.multiple_selection_type MultipleSelectionType,
		pv.product_issuer ProductIssuerType,
		pv.issue_merchant TXCIssueMerchant,
		--pv.pin_code_type PinCodeType,
		--pv.pin_code_length PinCodeLength,
		CASE r.pin_type WHEN 1 THEN 1 WHEN 2 THEN 1 WHEN 3 THEN 1 WHEN 4 THEN 2 WHEN 5 THEN 2 ELSE 0 END PinCodeType,
		CASE r.pin_type WHEN 1 THEN 4 WHEN 2 THEN 6 WHEN 3 THEN 8 WHEN 4 THEN 4 WHEN 5 THEN 6 ELSE 0 END PinCodeLength,
		p.is_master IsMasterProduct,
		pv.voucher_issuer_id MerchantAcquirerId,
		pv.product_tag ProductTag,
		pv.add_to_wallet AddToWallet,
		p.product_type ProductSubType,
		pv.brand_id TXCBrandId,
		pv.customer_service_note Memo,
		pv.wallet_status WalletStatus,
		pv.wallet_image TXCWalletImage,
		pv.product_category ProductCategory,
		pv.is_deferred_child IsDeferredChild,
		pv.can_extend CanExtend,
		pv.extension_scheme_id ExtensionSchemeId,
		pv.max_extend_times MaxExtendTimes,
		pv.extension_end_date ExtensionEndDate,
		pv.same_as_contract_end_date SameAsValidEndDateOnContract,
		p.created_by CreatedBy,
		p.created_on CreatedOn,
		pv.created_by Modifier,
		pv.version Version,
		ISNULL(pv.last_updated_on, pv.created_on) VersionTime,
		pv.is_current_version IsCurrentVersion,
		CASE WHEN pv.version = 1 THEN pv.template_id ELSE NULL END TXCProductTemplateId,
		CASE WHEN pv.version = 1 THEN pv.price_id ELSE NULL END TXCProductPriceId,
		CASE WHEN pv.version = 1 THEN pv.expiry_scheme_id ELSE NULL END TXCProductExpirySchemeId,
		CASE WHEN pv.version = 1 THEN pv.redeem_date_blacklist_id ELSE NULL END TXCProductRedeemDateBlacklistId,
		CASE WHEN pv.version = 1 THEN pv.redeem_time_restriction_id ELSE NULL END TXCProductRedeemTimeRestrictionId,
		--CASE WHEN pv.version = 1 OR ISNULL(pv.wallet_image, 0) <> 0 THEN pv.external_property_id ELSE NULL END TXCProductExternalPropertyId,
		pv.external_property_id TXCProductExternalPropertyId,
		CASE WHEN pv.version = 1 THEN pv.acceptance_loop_id ELSE NULL END TXCProductAcceptanceLoopId,
		pv.sku_id TXCProductSKUId,
		bt.description, --ShowcodeType
		r.dist_voucher_num_under_barcode, --DisplayText
		pv.is_fixed_expiry_policy,		
		r.has_multipart_barcode HasMultiBarcode,
		r.request_expiry_date RequireExpiryDate
	FROM product.tb_p_product p
	INNER JOIN product.tb_p_product_version pv on p.product_id = pv.product_id
	LEFT OUTER JOIN merchant_info.tb_contract_sku s ON pv.sku_id = s.id
	LEFT OUTER JOIN merchant_info.tb_vnr_voucher_number_rule r ON s.voucher_number_rule_id = r.id
	LEFT OUTER JOIN merchant_info.tb_bt_barcode_type bt ON r.barcode_type_id  = bt.id
	WHERE (pv.created_on > @sync_period_from AND pv.created_on <= @sync_period_to)
	OR (pv.last_updated_on > @sync_period_from AND pv.last_updated_on <= @sync_period_to)
	ORDER BY TXCProductId, TXCProductVersionId
	
	DECLARE @TXCProductId INT
	DECLARE @TXCProductVersionId INT
	
	DECLARE @version INT
	DECLARE @template_id INT
	DECLARE @price_id INT
	DECLARE @expiry_scheme_id INT
	DECLARE @redeem_date_blacklist_id INT
	DECLARE @redeem_time_restriction_id INT
	DECLARE @external_property_id INT
	DECLARE @acceptance_loop_id INT
	DECLARE @sku_id INT
	DECLARE @wallet_image INT
	
	DECLARE C CURSOR FOR
	SELECT TXCProductId, TXCProductVersionId FROM @T WHERE TXCProductVersionId > 1
	
	OPEN C;
	FETCH NEXT FROM C INTO @TXCProductId, @TXCProductVersionId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @version = version,
			@template_id = ISNULL(template_id, 0),
			@price_id = ISNULL(price_id, 0),
			@expiry_scheme_id = ISNULL(expiry_scheme_id, 0),
			@redeem_date_blacklist_id = ISNULL(redeem_date_blacklist_id, 0),
			@redeem_time_restriction_id = ISNULL(redeem_time_restriction_id, 0),
			--@external_property_id = ISNULL(external_property_id, 0),
			@acceptance_loop_id = ISNULL(acceptance_loop_id, 0),
			@sku_id = sku_id,
			@wallet_image = ISNULL(wallet_image, 0)
		FROM product.tb_p_product_version
		WHERE product_version_id = @TXCProductVersionId
	
		UPDATE @T SET
			TXCProductTemplateId = CASE WHEN ISNULL(pv.template_id, 0) <> @template_id THEN @template_id ELSE NULL END,
			TXCProductPriceId = CASE WHEN (ISNULL(price_id, 0) <> @price_id) OR (sku_id <> @sku_id) THEN @price_id ELSE NULL END,
			TXCProductExpirySchemeId = CASE WHEN ISNULL(expiry_scheme_id, 0) <> @expiry_scheme_id THEN @expiry_scheme_id ELSE NULL END,
			TXCProductRedeemDateBlacklistId = CASE WHEN ISNULL(redeem_date_blacklist_id, 0) <> @redeem_date_blacklist_id THEN @redeem_date_blacklist_id ELSE NULL END,
			TXCProductRedeemTimeRestrictionId = CASE WHEN ISNULL(redeem_time_restriction_id, 0) <> @redeem_time_restriction_id THEN @redeem_time_restriction_id ELSE NULL END,
			--TXCProductExternalPropertyId = CASE WHEN ISNULL(external_property_id, 0) <> @external_property_id OR ISNULL(@wallet_image, 0) <> 0 THEN @external_property_id ELSE NULL END,
			TXCProductAcceptanceLoopId = CASE WHEN acceptance_loop_id <> @acceptance_loop_id THEN @acceptance_loop_id ELSE NULL END
			--TXCProductSKUId = CASE WHEN sku_id <> @sku_id THEN @sku_id ELSE NULL END
		FROM product.tb_p_product_version pv
		WHERE pv.product_id = @TXCProductId AND pv.version = @version - 1
		AND TXCProductId = @TXCProductId AND TXCProductVersionId = @TXCProductVersionId
		
		FETCH NEXT FROM C INTO @TXCProductId, @TXCProductVersionId
	END
	
	CLOSE C
	DEALLOCATE C
	
	SELECT * FROM @T
END