

CREATE PROCEDURE [dbo].[sp_sync_product]
@RunId varchar(50),
@TimeOffsetMinute int
AS
BEGIN
	-- Convert StopIssueTime and ExpirationDate by tenant's time offset
	UPDATE TXCProductSync SET
		StopIssueTime = DATEADD(MINUTE, @TimeOffsetMinute, StopIssueTime),
		ExpirationDate = DATEADD(MINUTE, @TimeOffsetMinute, ExpirationDate),
		CreatedOn = DATEADD(MINUTE, @TimeOffsetMinute, CreatedOn),
		VersionTime = DATEADD(MINUTE, @TimeOffsetMinute, VersionTime)
	WHERE RunId = @RunId
	
	DECLARE @ProductId int
	DECLARE @ProductVersionId int
	DECLARE @ProgramId int
	DECLARE @ProductCode varchar(50)
	DECLARE @ExternalProductCode varchar(50)
	DECLARE @ProductName nvarchar(200)
	DECLARE @Description nvarchar(500)
	DECLARE @Note nvarchar(max)
	DECLARE @VoucherNumberGenerateWay tinyint
	DECLARE @VoucherNumberRuleId int
	DECLARE @ProductType tinyint
	DECLARE @CanTopup bit
	DECLARE @MinRedeemQuantity int
	DECLARE @MaxIssuingQuantity int
	DECLARE @ValidFrom datetime
	DECLARE @ValidTo datetime
	DECLARE @ReverseLimitId int
	DECLARE @PreAuthorizationExpiryInterval int
	DECLARE @PreAuthorizationExpiryUnit tinyint
	DECLARE @UseTimeControl smallint
	DECLARE @UseTimeControlInterval smallint
	DECLARE @MaxTotalRedeemAmountControl int
	DECLARE @MaxTotalRedeemAmountControlInterval smallint
	DECLARE @MaxSingleRedeemAmount int
	DECLARE @Status tinyint
	DECLARE @ExpirationDate datetime
	DECLARE @BrandStory nvarchar(500)
	DECLARE @CanIssue bit
	DECLARE @StopIssueTime datetime
	DECLARE @ReminderId int
	DECLARE @MultipleSelectionType tinyint
	DECLARE @ProductIssuerType tinyint
	DECLARE @IssueMerchant int
	DECLARE @PinCodeType tinyint
	DECLARE @PinCodeLength tinyint
	DECLARE @IsMasterProduct bit
	DECLARE @MerchantAcquirerId int
	DECLARE @ProductTag int
	DECLARE @AddToWallet bit
	DECLARE @ProductSubType int
	DECLARE @BrandId int
	DECLARE @Memo nvarchar(2000)
	DECLARE @WalletStatus int
	DECLARE @ProductCategory int
	DECLARE @IsDeferredChild bit
	DECLARE @CanExtend bit
	DECLARE @ExtensionSchemeId int
	DECLARE @MaxExtendTimes int
	DECLARE @ExtensionEndDate datetime
	DECLARE @SameAsValidEndDateOnContract bit
	DECLARE @CreatedBy nvarchar(50)
	DECLARE @CreatedOn datetime
	DECLARE @Modifier nvarchar(50)
	DECLARE @Version int
	DECLARE @VersionTime datetime
	DECLARE @IsCurrentVersion bit
	
	DECLARE @ProductEmailTemplateVersionId INT
	DECLARE @ProductSLMSTemplateVersionId INT
	DECLARE @ProductPricingProductBasedId INT
	DECLARE @ProductPricingValueBasedId INT
	DECLARE @ProductExpirySchemeId INT
	DECLARE @ProductRedeemDateBlacklistId INT
	DECLARE @ProductRedeemTimeRestrictionId INT
	DECLARE @ProductExternalPropertyId INT
	DECLARE @ProductAcceptanceLoopId INT
	DECLARE @IsMultiBrand BIT
	DECLARE @ShowcodeType VARCHAR(20)
	DECLARE @DisplayText BIT
	DECLARE @TXCProductPriceId INT
	
	DECLARE @RequireExpiryDate bit
	DECLARE @HasMultiBarcode bit
	
	BEGIN TRAN
	BEGIN TRY
		DECLARE C CURSOR FOR
		SELECT ProductId, ProductVersionId, ProgramId, ProductCode, ExternalProductCode, ProductName, Description, Note, VoucherNumberGenerateWay, VoucherNumberRuleId, ProductType, CanTopup, MinRedeemQuantity, MaxIssuingQuantity, ValidFrom, ValidTo, ReverseLimitId, PreAuthorizationExpiryInterval, PreAuthorizationExpiryUnit, UseTimeControl, UseTimeControlInterval, MaxTotalRedeemAmountControl, MaxTotalRedeemAmountControlInterval, MaxSingleRedeemAmount, Status, ExpirationDate, BrandStory, CanIssue, StopIssueTime, ReminderId, MultipleSelectionType, ProductIssuerType, IssueMerchant, PinCodeType, PinCodeLength, IsMasterProduct, MerchantAcquirerId, ProductTag, AddToWallet, ProductSubType, BrandId, Memo, WalletStatus, ProductCategory, IsDeferredChild, CanExtend, ExtensionSchemeId, MaxExtendTimes, ExtensionEndDate, SameAsValidEndDateOnContract, CreatedBy, CreatedOn, Modifier, Version, VersionTime, IsCurrentVersion, ProductEmailTemplateVersionId, ProductSLMSTemplateVersionId, ProductPricingProductBasedId, ProductPricingValueBasedId, ProductExpirySchemeId, ProductRedeemDateBlacklistId, ProductRedeemTimeRestrictionId, ProductExternalPropertyId, ProductAcceptanceLoopId, IsMultiBrand, ShowcodeType, DisplayText, TXCProductPriceId,RequireExpiryDate,HasMultiBarcode
		FROM TXCProductSync 
		WHERE RunId = @RunId ORDER BY TXCProductId, TXCProductVersionId
		
		OPEN C;
		FETCH NEXT FROM C INTO @ProductId, @ProductVersionId, @ProgramId, @ProductCode, @ExternalProductCode, @ProductName, @Description, @Note, @VoucherNumberGenerateWay, @VoucherNumberRuleId, @ProductType, @CanTopup, @MinRedeemQuantity, @MaxIssuingQuantity, @ValidFrom, @ValidTo, @ReverseLimitId, @PreAuthorizationExpiryInterval, @PreAuthorizationExpiryUnit, @UseTimeControl, @UseTimeControlInterval, @MaxTotalRedeemAmountControl, @MaxTotalRedeemAmountControlInterval, @MaxSingleRedeemAmount, @Status, @ExpirationDate, @BrandStory, @CanIssue, @StopIssueTime, @ReminderId, @MultipleSelectionType, @ProductIssuerType, @IssueMerchant, @PinCodeType, @PinCodeLength, @IsMasterProduct, @MerchantAcquirerId, @ProductTag, @AddToWallet, @ProductSubType, @BrandId, @Memo, @WalletStatus, @ProductCategory, @IsDeferredChild, @CanExtend, @ExtensionSchemeId, @MaxExtendTimes, @ExtensionEndDate, @SameAsValidEndDateOnContract, @CreatedBy, @CreatedOn, @Modifier, @Version, @VersionTime, @IsCurrentVersion, @ProductEmailTemplateVersionId, @ProductSLMSTemplateVersionId, @ProductPricingProductBasedId, @ProductPricingValueBasedId, @ProductExpirySchemeId, @ProductRedeemDateBlacklistId, @ProductRedeemTimeRestrictionId, @ProductExternalPropertyId, @ProductAcceptanceLoopId, @IsMultiBrand, @ShowcodeType, @DisplayText, @TXCProductPriceId,@RequireExpiryDate,@HasMultiBarcode
		
		WHILE @@FETCH_STATUS = 0
		BEGIN			
			SELECT
			  @ReminderId = DictionaryId
			FROM TXCDictionaryMapping
			WHERE ExternalId = @ReminderId

			SELECT
			  @MerchantAcquirerId = DictionaryId
			FROM TXCDictionaryMapping
			WHERE ExternalId = @MerchantAcquirerId

			-- If the product exists in TX2, update the product attributes
			IF EXISTS (SELECT 1 FROM Product WHERE Id = @ProductId)
			BEGIN
				-- Update Product
				UPDATE Product SET
					ExternalProductCode = @ExternalProductCode,
					ProductName = @ProductName,
					Description = @Description,
					Note = @Note,
					VoucherNumberGenerateWay = @VoucherNumberGenerateWay,
					VoucherNumberRuleId = @VoucherNumberRuleId,
					MinRedeemQuantity = @MinRedeemQuantity,
					MaxIssuingQuantity = @MaxIssuingQuantity,
					ValidFrom = @ValidFrom,
					ValidTo = @ValidTo,
					ReverseLimitId = @ReverseLimitId,
					PreAuthorizationExpiryInterval = @PreAuthorizationExpiryInterval,
					PreAuthorizationExpiryUnit = @PreAuthorizationExpiryUnit,
					UseTimeControl = @UseTimeControl,
					UseTimeControlInterval = @UseTimeControlInterval,
					MaxTotalRedeemAmountControl = @MaxTotalRedeemAmountControl,
					MaxTotalRedeemAmountControlInterval = @MaxTotalRedeemAmountControlInterval,
					MaxSingleRedeemAmount = @MaxSingleRedeemAmount,
					BrandStory = @BrandStory,
					ReminderId = @ReminderId,
					MultipleSelectionType = @MultipleSelectionType,
					ProductIssuerType = @ProductIssuerType,
					IssueMerchant = @IssueMerchant,
					PinCodeType = @PinCodeType,
					PinCodeLength = @PinCodeLength,
					MerchantAcquirerId = @MerchantAcquirerId,
					ProductTag = @ProductTag,
					AddToWallet = @AddToWallet,
					BrandId = @BrandId,
					Memo = @Memo,
					WalletStatus = @WalletStatus,
					ProductCategory = @ProductCategory,
					IsDeferredChild = @IsDeferredChild,
					CanExtend = @CanExtend,
					ExtensionSchemeId = NULL,
					MaxExtendTimes = @MaxExtendTimes,
					ExtensionEndDate = @ExtensionEndDate,
					SameAsValidEndDateOnContract = @SameAsValidEndDateOnContract,
					Status = @Status,
					CanIssue = CASE WHEN @StopIssueTime IS NULL THEN 1 ELSE 0 END,
					StopIssueTime = @StopIssueTime,
					ProductEmailTemplateVersionId = ISNULL(@ProductEmailTemplateVersionId, ProductEmailTemplateVersionId),
					ProductSLMSTemplateVersionId = ISNULL(@ProductSLMSTemplateVersionId, ProductSLMSTemplateVersionId),
					ProductExpirySchemeId = ISNULL(@ProductExpirySchemeId, ProductExpirySchemeId),
					RedeemDateBlacklistId = ISNULL(@ProductRedeemDateBlacklistId, RedeemDateBlacklistId),
					RedeemTimeRestrictionId = ISNULL(@ProductRedeemTimeRestrictionId, RedeemTimeRestrictionId),
					ExternalPropertyId = ISNULL(@ProductExternalPropertyId, ExternalPropertyId),
					AcceptanceLoopId = ISNULL(@ProductAcceptanceLoopId, AcceptanceLoopId),
					IsMultiBrand = ISNULL(@IsMultiBrand, IsMultiBrand),
					RequireExpiryDate = ISNULL(@RequireExpiryDate, 0)
				WHERE Id = @ProductId

				IF (@ProductExpirySchemeId IS NOT NULL)
				BEGIN
					-- Update Product
					UPDATE Product SET						
						ExpirationDate = @ExpirationDate						
					WHERE Id = @ProductId
				END
			END
			
			-- If the product does not exist in TX2, insert new product
			ELSE
			BEGIN
				-- Lookup voucher import template by program ID
				-- If not found, use the default voucher import template
				DECLARE @VoucherImportTemplateId INT = NULL
				
				SELECT TOP 1 @VoucherImportTemplateId = Id FROM VoucherImportTemplate WHERE ProgramId = @ProgramId ORDER BY Id
				IF @VoucherImportTemplateId IS NULL
				SELECT TOP 1 @VoucherImportTemplateId = Id FROM VoucherImportTemplate WHERE ProgramId IS NULL ORDER BY Id
				
				SET IDENTITY_INSERT Product ON;
				
				-- Insert Product
				INSERT INTO Product (Id, ProgramId, ProductCode, ExternalProductCode, ProductName, Description, Note, VoucherNumberGenerateWay, VoucherNumberRuleId, EmailTemplateVersionId, EmailTemplateTagValueId, SLMSTemplateVersionId, SLMSTemplateTagValueId, IsMultiBrand, AcceptanceLoopId, ProductType, CanTopup, MinRedeemQuantity, MaxIssuingQuantity, ValidFrom, ValidTo, RedeemDateBlacklistId, ReverseLimitId, PreAuthorizationExpiryInterval, PreAuthorizationExpiryUnit, RedeemTimeRestrictionId, ProductExpirySchemeId, UseTimeControl, UseTimeControlInterval, MaxTotalRedeemAmountControl, MaxTotalRedeemAmountControlInterval, MaxSingleRedeemAmount, ExternalPropertyId, Status, CreatedBy, CreatedOn, ExpirationDate, APICacheHW, APICacheLW, BrandStory, CanIssue, StopIssueTime, VoucherImportTemplateId, ReminderId, ProductCustomizedEmailTemplateVersionId, ProductCustomizedSLMSTemplateVersionId, VoucherSupplierId, MultipleSelectionType, ProductIssuerType, IssueMerchant, RequireExpiryDate, ProductEmailTemplateVersionId, ProductSLMSTemplateVersionId, PinCodeType, PinCodeLength, IsMasterProduct, ProductComboId, MerchantAcquirerId, ProductTag, AddToWallet, ProductSubType, BrandId, Memo, WalletStatus, ProductCategory, IsDeferredChild, CanExtend, ExtensionSchemeId, MaxExtendTimes, ExtensionEndDate, SameAsValidEndDateOnContract)
				VALUES (
					@ProductId, 
					@ProgramId, 
					@ProductCode, 
					@ExternalProductCode, 
					@ProductName, 
					@Description, 
					@Note, 
					@VoucherNumberGenerateWay, --VoucherNumberGenerateWay 
					@VoucherNumberRuleId, --VoucherNumberRuleId
					NULL, --EmailTemplateVersionId
					NULL, --EmailTemplateTagValueId
					NULL, --SLMSTemplateVersionId
					NULL, --SLMSTemplateTagValueId
					@IsMultiBrand,
					@ProductAcceptanceLoopId, --AcceptanceLoopId
					@ProductType, 
					@CanTopup, 
					@MinRedeemQuantity, 
					@MaxIssuingQuantity, 
					@ValidFrom, 
					@ValidTo, 
					@ProductRedeemDateBlacklistId, --RedeemDateBlacklistId
					@ReverseLimitId, 
					@PreAuthorizationExpiryInterval, 
					@PreAuthorizationExpiryUnit, 
					@ProductRedeemTimeRestrictionId, --RedeemTimeRestrictionId
					@ProductExpirySchemeId, --ProductExpirySchemeId
					@UseTimeControl, 
					@UseTimeControlInterval, 
					@MaxTotalRedeemAmountControl, 
					@MaxTotalRedeemAmountControlInterval, 
					@MaxSingleRedeemAmount, 
					@ProductExternalPropertyId, --ExternalPropertyId, 
					@Status, 
					@CreatedBy, 
					@CreatedOn, 
					@ExpirationDate, 
					NULL, --APICacheHW, 
					NULL, --APICacheLW, 
					@BrandStory, 
					CASE WHEN @StopIssueTime IS NULL THEN 1 ELSE 0 END, --CanIssue
					@StopIssueTime, 
					@VoucherImportTemplateId, 
					@ReminderId, --ReminderId, 
					NULL, --ProductCustomizedEmailTemplateVersionId, 
					NULL, --ProductCustomizedSLMSTemplateVersionId, 
					NULL, --VoucherSupplierId, 
					@MultipleSelectionType, 
					@ProductIssuerType, 
					@IssueMerchant, 
					ISNULL(@RequireExpiryDate, 0), 
					@ProductEmailTemplateVersionId, --ProductEmailTemplateVersionId, 
					@ProductSLMSTemplateVersionId, --ProductSLMSTemplateVersionId, 
					@PinCodeType, 
					@PinCodeLength, 
					@IsMasterProduct, 
					NULL, --ProductComboId,
					@MerchantAcquirerId, 
					@ProductTag, 
					@AddToWallet, 
					@ProductSubType, 
					@BrandId, 
					@Memo, 
					@WalletStatus, 
					@ProductCategory, 
					@IsDeferredChild, 
					@CanExtend, 
					NULL, --@ExtensionSchemeId, 
					@MaxExtendTimes, 
					@ExtensionEndDate, 
					@SameAsValidEndDateOnContract
				)
				
				SET IDENTITY_INSERT Product OFF;
				
				-- Insert TXCProductMapping
				IF NOT EXISTS (SELECT 1 FROM TXCProductMapping WHERE ProductId = @ProductId)
				BEGIN
					INSERT INTO TXCProductMapping
					SELECT @ProductId, Id, @ProductId
					FROM TXCTenant
				END
			END
			
			-- If the product version exists in TX2, update the product version attributes
			IF EXISTS (SELECT 1 FROM ProductVersion WHERE Id = @ProductVersionId)
			BEGIN
				-- Update ProductVersion
				UPDATE ProductVersion SET
					ProgramId = @ProgramId,
					ProductId = @ProductId,
					ExternalProductCode = @ExternalProductCode,
					ProductName = @ProductName,
					Description = @Description,
					Note = @Note,
					MinRedeemQuantity = @MinRedeemQuantity,
					MaxIssuingQuantity = @MaxIssuingQuantity,
					ValidFrom = @ValidFrom,
					ValidTo = @ValidTo,
					ReverseLimitId = @ReverseLimitId,
					PreAuthorizationExpiryInterval = @PreAuthorizationExpiryInterval,
					PreAuthorizationExpiryUnit = @PreAuthorizationExpiryUnit,
					UseTimeControl = @UseTimeControl,
					UseTimeControlInterval = @UseTimeControlInterval,
					MaxSingleRedeemAmount = @MaxSingleRedeemAmount,
					Modifier = @Modifier,
					Version = @Version,
					VersionTime = @VersionTime,
					IsCurrentVersion = @IsCurrentVersion,
					BrandStory = @BrandStory,
					MultipleSelectionType = @MultipleSelectionType,
					ProductIssuerType = @ProductIssuerType,
					IssueMerchant = @IssueMerchant,
					PinCodeType = @PinCodeType,
					PinCodeLength = @PinCodeLength,
					IsMasterProduct = @IsMasterProduct,
					ProductTag = @ProductTag,
					AddToWallet = @AddToWallet,
					ProductCategory = @ProductCategory,
					CanExtend = @CanExtend,
					--ExtensionSchemeId = @ExtensionSchemeId,
					MaxExtendTimes = @MaxExtendTimes,
					ExtensionEndDate = @ExtensionEndDate,
					SameAsValidEndDateOnContract = @SameAsValidEndDateOnContract
				WHERE Id = @ProductVersionId
				
				-- Update the reference ID if there is update at the entity. Else, remain the same reference ID
				UPDATE ProductVersion SET
					ProductEmailTemplateVersionId = ISNULL(@ProductEmailTemplateVersionId, ProductEmailTemplateVersionId),
					ProductSLMSTemplateVersionId = ISNULL(@ProductSLMSTemplateVersionId, ProductSLMSTemplateVersionId),
					ProductPricingProductBasedId = ISNULL(@ProductPricingProductBasedId, ProductPricingProductBasedId),
					ProductPricingValueBasedId = ISNULL(@ProductPricingValueBasedId, ProductPricingValueBasedId),
					ProductExpirySchemeId = ISNULL(@ProductExpirySchemeId, ProductExpirySchemeId),
					RedeemDateBlacklistId = ISNULL(@ProductRedeemDateBlacklistId, RedeemDateBlacklistId),
					RedeemTimeRestrictionId = ISNULL(@ProductRedeemTimeRestrictionId, RedeemTimeRestrictionId),
					ExternalPropertyId = ISNULL(@ProductExternalPropertyId, ExternalPropertyId),
					AcceptanceLoopId = ISNULL(@ProductAcceptanceLoopId, AcceptanceLoopId),
					IsMultiBrand = ISNULL(@IsMultiBrand, IsMultiBrand)
				WHERE Id = @ProductVersionId
			END
			
			-- If the product version does not exist in TX2, insert new product version
			ELSE
			BEGIN
				-- Insert ProductVersion
				IF @Version = 1
				BEGIN
					SET IDENTITY_INSERT ProductVersion ON;
					
					-- Insert ProductVersion (Version 1)
					INSERT INTO ProductVersion (Id, ProgramId, ProductId, ExternalProductCode, ProductName, Description, Note, EmailTemplateVersionId, EmailTemplateTagValueId, SLMSTemplateVersionId, SLMSTemplateTagValueId, IsMultiBrand, AcceptanceLoopId, ProductPricingProductBasedId, ProductPricingValueBasedId, MinRedeemQuantity, MaxIssuingQuantity, ValidFrom, ValidTo, RedeemDateBlacklistId, ReverseLimitId, PreAuthorizationExpiryInterval, PreAuthorizationExpiryUnit, RedeemTimeRestrictionId, ProductExpirySchemeId, UseTimeControl, UseTimeControlInterval, MaxTotalRedeemAmountControl, MaxTotalRedeemAmountControlInterval, MaxSingleRedeemAmount, ExternalPropertyId, Modifier, Version, VersionTime, IsCurrentVersion, APICacheHW, APICacheLW, BrandStory, MultipleSelectionType, ProductIssuerType, IssueMerchant, ProductEmailTemplateVersionId, ProductSLMSTemplateVersionId, PinCodeType, PinCodeLength, IsMasterProduct, ProductComboId, ProductTag, AddToWallet, ProductCategory, CanExtend, ExtensionSchemeId, MaxExtendTimes, ExtensionEndDate, SameAsValidEndDateOnContract)
					VALUES
					(
						@ProductVersionId, 
						@ProgramId, 
						@ProductId, 
						@ExternalProductCode, 
						@ProductName, 
						@Description, 
						@Note, 
						NULL, --EmailTemplateVersionId, 
						NULL, --EmailTemplateTagValueId, 
						NULL, --SLMSTemplateVersionId, 
						NULL, --SLMSTemplateTagValueId, 
						@IsMultiBrand, 
						@ProductAcceptanceLoopId, --AcceptanceLoopId, 
						@ProductPricingProductBasedId, --ProductPricingProductBasedId, 
						@ProductPricingValueBasedId, --ProductPricingValueBasedId, 
						@MinRedeemQuantity, 
						@MaxIssuingQuantity, 
						@ValidFrom, 
						@ValidTo, 
						@ProductRedeemDateBlacklistId, --RedeemDateBlacklistId, 
						@ReverseLimitId, 
						@PreAuthorizationExpiryInterval, 
						@PreAuthorizationExpiryUnit, 
						@ProductRedeemTimeRestrictionId, --RedeemTimeRestrictionId, 
						@ProductExpirySchemeId, --ProductExpirySchemeId, 
						@UseTimeControl, 
						@UseTimeControlInterval, 
						@MaxTotalRedeemAmountControl, 
						@MaxTotalRedeemAmountControlInterval, 
						@MaxSingleRedeemAmount, 
						@ProductExternalPropertyId, --ExternalPropertyId, 
						@Modifier, 
						@Version, 
						@VersionTime, 
						@IsCurrentVersion, 
						NULL, --APICacheHW, 
						NULL, --APICacheLW, 
						@BrandStory, 
						@MultipleSelectionType, 
						@ProductIssuerType, 
						@IssueMerchant, 
						@ProductEmailTemplateVersionId, --ProductEmailTemplateVersionId, 
						@ProductSLMSTemplateVersionId, --ProductSLMSTemplateVersionId, 
						@PinCodeType, 
						@PinCodeLength, 
						@IsMasterProduct, 
						NULL, --ProductComboId, 
						@ProductTag, 
						@AddToWallet, 
						@ProductCategory, 
						@CanExtend, 
						NULL, --@ExtensionSchemeId, 
						@MaxExtendTimes, 
						@ExtensionEndDate, 
						@SameAsValidEndDateOnContract
					)
					
					SET IDENTITY_INSERT ProductVersion OFF;
				END
				ELSE
				BEGIN
					SET IDENTITY_INSERT ProductVersion ON;
					
					-- Insert ProductVersion (Version > 1)
					INSERT INTO ProductVersion ([Id], [ProgramId], [ProductId], [ExternalProductCode], [ProductName], [Description], [Note], [EmailTemplateVersionId], [EmailTemplateTagValueId], [SLMSTemplateVersionId], [SLMSTemplateTagValueId], [IsMultiBrand], [AcceptanceLoopId], [ProductPricingProductBasedId], [ProductPricingValueBasedId], [MinRedeemQuantity], [MaxIssuingQuantity], [ValidFrom], [ValidTo], [RedeemDateBlacklistId], [ReverseLimitId], [PreAuthorizationExpiryInterval], [PreAuthorizationExpiryUnit], [RedeemTimeRestrictionId], [ProductExpirySchemeId], [UseTimeControl], [UseTimeControlInterval], [MaxTotalRedeemAmountControl], [MaxTotalRedeemAmountControlInterval], [MaxSingleRedeemAmount], [ExternalPropertyId], [Modifier], [Version], [VersionTime], [IsCurrentVersion], [APICacheHW], [APICacheLW], [BrandStory], [MultipleSelectionType], [ProductIssuerType], [IssueMerchant], [ProductEmailTemplateVersionId], [ProductSLMSTemplateVersionId], [PinCodeType], [PinCodeLength], [IsMasterProduct], [ProductComboId], [ProductTag], [AddToWallet], [ProductCategory], [CanExtend], [ExtensionSchemeId], [MaxExtendTimes], [ExtensionEndDate], [SameAsValidEndDateOnContract])
					SELECT @ProductVersionId, @ProgramId, @ProductId, @ExternalProductCode, @ProductName, @Description, @Note, [EmailTemplateVersionId], [EmailTemplateTagValueId], [SLMSTemplateVersionId], [SLMSTemplateTagValueId], [IsMultiBrand], [AcceptanceLoopId], [ProductPricingProductBasedId], [ProductPricingValueBasedId], @MinRedeemQuantity, @MaxIssuingQuantity, @ValidFrom, @ValidTo, [RedeemDateBlacklistId], @ReverseLimitId, @PreAuthorizationExpiryInterval, @PreAuthorizationExpiryUnit, [RedeemTimeRestrictionId], [ProductExpirySchemeId], @UseTimeControl, @UseTimeControlInterval, @MaxTotalRedeemAmountControl, @MaxTotalRedeemAmountControlInterval, @MaxSingleRedeemAmount, [ExternalPropertyId], @Modifier, @Version, @VersionTime, @IsCurrentVersion, [APICacheHW], [APICacheLW], @BrandStory, @MultipleSelectionType, @ProductIssuerType, @IssueMerchant, [ProductEmailTemplateVersionId], [ProductSLMSTemplateVersionId], @PinCodeType, @PinCodeLength, @IsMasterProduct, [ProductComboId], @ProductTag, @AddToWallet, @ProductCategory, @CanExtend, NULL, @MaxExtendTimes, @ExtensionEndDate, @SameAsValidEndDateOnContract
					FROM ProductVersion WHERE ProductId = @ProductId AND Version = @Version - 1
					
					SET IDENTITY_INSERT ProductVersion OFF;
					
					UPDATE ProductVersion SET
						ProductEmailTemplateVersionId = ISNULL(@ProductEmailTemplateVersionId, ProductEmailTemplateVersionId),
						ProductSLMSTemplateVersionId = ISNULL(@ProductSLMSTemplateVersionId, ProductSLMSTemplateVersionId),
						ProductPricingProductBasedId = ISNULL(@ProductPricingProductBasedId, ProductPricingProductBasedId),
						ProductPricingValueBasedId = ISNULL(@ProductPricingValueBasedId, ProductPricingValueBasedId),
						ProductExpirySchemeId = ISNULL(@ProductExpirySchemeId, ProductExpirySchemeId),
						RedeemDateBlacklistId = ISNULL(@ProductRedeemDateBlacklistId, RedeemDateBlacklistId),
						RedeemTimeRestrictionId = ISNULL(@ProductRedeemTimeRestrictionId, RedeemTimeRestrictionId),
						ExternalPropertyId = ISNULL(@ProductExternalPropertyId, ExternalPropertyId),
						AcceptanceLoopId = ISNULL(@ProductAcceptanceLoopId, AcceptanceLoopId),
						IsMultiBrand = ISNULL(@IsMultiBrand, IsMultiBrand)
					WHERE ProductId = @ProductId AND Version = @Version
				END
				
				-- Insert TXCProductVersionMapping
				IF NOT EXISTS (SELECT 1 FROM TXCProductVersionMapping WHERE ProductVersionId = @ProductVersionId)
				BEGIN
					INSERT INTO TXCProductVersionMapping
					SELECT @ProductVersionId, Id, @ProductVersionId
					FROM TXCTenant
				END
				
				-- Obsolete previous product versions
				UPDATE ProductVersion SET IsCurrentVersion = 0
				WHERE ProductId = @ProductId AND Version < @Version
			END
			
			-- For dynamic face value
			IF @ProductSubType = 4
			BEGIN
				-- If product price is updated in TXC, insert/update DFV price in TX2
				IF @TXCProductPriceId IS NOT NULL
				BEGIN
					IF EXISTS (SELECT 1 FROM ProductPricingDynamicFaceValue WHERE ProductVersionId = @ProductVersionId)
					BEGIN
						UPDATE ProductPricingDynamicFaceValue SET DefaultSellingPrice = ISNULL(S.DefaultSellingPrice, 0.0), DefaultProductCost = S.DefaultProductCost
						FROM TXCProductPriceSync S
						WHERE ProductPricingDynamicFaceValue.ProductVersionId = @ProductVersionId AND RunId = @RunId AND S.TXCProductPriceId = @TXCProductPriceId
					END
					ELSE
					BEGIN
						INSERT INTO ProductPricingDynamicFaceValue (ProductVersionId, DefaultSellingPrice, DefaultProductCost)
						SELECT @ProductVersionId, ISNULL(DefaultSellingPrice, 0.0) , DefaultProductCost
						FROM TXCProductPriceSync
						WHERE RunId = @RunId AND TXCProductPriceId = @TXCProductPriceId
					END
				END
				
				-- For existing product, copy DFV price from previous product version
				ELSE IF @Version > 1
				BEGIN
					DECLARE @DefaultSellingPrice DECIMAL(10,4)
					DECLARE @DefaultProductCost DECIMAL(10,4)
					
					SELECT @DefaultSellingPrice = ppdfv.DefaultSellingPrice, @DefaultProductCost = ppdfv.DefaultProductCost
					FROM ProductPricingDynamicFaceValue ppdfv
					INNER JOIN ProductVersion pv ON ppdfv.ProductVersionId = pv.Id
					WHERE pv.ProductId = @ProductId AND pv.Version = @Version - 1
					
					IF EXISTS (SELECT 1 FROM ProductPricingDynamicFaceValue WHERE ProductVersionId = @ProductVersionId)
					BEGIN
						UPDATE ProductPricingDynamicFaceValue SET DefaultSellingPrice = @DefaultSellingPrice, @DefaultProductCost = DefaultProductCost
						FROM ProductPricingDynamicFaceValue
						WHERE ProductVersionId = @ProductVersionId
					END
					ELSE
					BEGIN
						INSERT INTO ProductPricingDynamicFaceValue (ProductVersionId, DefaultSellingPrice, DefaultProductCost)
						VALUES (@ProductVersionId, @DefaultSellingPrice, @DefaultProductCost)
					END
				END
			END
			
			-- Set the product's showcode type and display text into product barcode setting
			IF @ShowcodeType IS NOT NULL
			BEGIN
				IF EXISTS (SELECT 1 FROM ProductBarcodeSetting WHERE Id = @ProductId)
				BEGIN
					UPDATE ProductBarcodeSetting SET
						ShowcodeType = @ShowcodeType,
						IsShowcodeTypeDisplayText = @DisplayText,
						IsShowcodeTypeEnabled = 1
					WHERE Id = @ProductId
				END
				ELSE
				BEGIN
					INSERT INTO ProductBarcodeSetting (Id, ShowcodeType, IsShowcodeTypeDisplayText, IsShowcodeTypeEnabled)
					VALUES (@ProductId, @ShowcodeType, @DisplayText, 1)
				END
				
				IF @HasMultiBarcode = 1
				BEGIN
					UPDATE ProductBarcodeSetting
					SET ProductBarcodeSetting.Barcode1Type = ProgramBarcodeSetting.Barcode1Type,
						ProductBarcodeSetting.IsBarcode1DisplayText = ProgramBarcodeSetting.IsBarcode1DisplayText,
						ProductBarcodeSetting.IsBarcode1APIEnabled = ProgramBarcodeSetting.IsBarcode1APIEnabled,
						ProductBarcodeSetting.Barcode2Type = ProgramBarcodeSetting.Barcode2Type,
						ProductBarcodeSetting.IsBarcode2DisplayText = ProgramBarcodeSetting.IsBarcode2DisplayText,
						ProductBarcodeSetting.IsBarcode2APIEnabled = ProgramBarcodeSetting.IsBarcode2APIEnabled,
						ProductBarcodeSetting.Barcode3Type = ProgramBarcodeSetting.Barcode3Type,
						ProductBarcodeSetting.IsBarcode3DisplayText = ProgramBarcodeSetting.IsBarcode3DisplayText,
						ProductBarcodeSetting.IsBarcode3APIEnabled = ProgramBarcodeSetting.IsBarcode3APIEnabled,
						ProductBarcodeSetting.Barcode4Type = ProgramBarcodeSetting.Barcode4Type,
						ProductBarcodeSetting.IsBarcode4DisplayText = ProgramBarcodeSetting.IsBarcode4DisplayText,
						ProductBarcodeSetting.IsBarcode4APIEnabled = ProgramBarcodeSetting.IsBarcode4APIEnabled,
						ProductBarcodeSetting.ShowcodeType = null,
						ProductBarcodeSetting.IsShowcodeTypeDisplayText = null,
						ProductBarcodeSetting.IsShowcodeTypeEnabled = null
					FROM ProductBarcodeSetting , ProgramBarcodeSetting
					WHERE ProductBarcodeSetting.Id = @ProductId AND ProgramBarcodeSetting.Id = @ProgramId
				END
			END
			
			FETCH NEXT FROM C INTO @ProductId, @ProductVersionId, @ProgramId, @ProductCode, @ExternalProductCode, @ProductName, @Description, @Note, @VoucherNumberGenerateWay, @VoucherNumberRuleId, @ProductType, @CanTopup, @MinRedeemQuantity, @MaxIssuingQuantity, @ValidFrom, @ValidTo, @ReverseLimitId, @PreAuthorizationExpiryInterval, @PreAuthorizationExpiryUnit, @UseTimeControl, @UseTimeControlInterval, @MaxTotalRedeemAmountControl, @MaxTotalRedeemAmountControlInterval, @MaxSingleRedeemAmount, @Status, @ExpirationDate, @BrandStory, @CanIssue, @StopIssueTime, @ReminderId, @MultipleSelectionType, @ProductIssuerType, @IssueMerchant, @PinCodeType, @PinCodeLength, @IsMasterProduct, @MerchantAcquirerId, @ProductTag, @AddToWallet, @ProductSubType, @BrandId, @Memo, @WalletStatus, @ProductCategory, @IsDeferredChild, @CanExtend, @ExtensionSchemeId, @MaxExtendTimes, @ExtensionEndDate, @SameAsValidEndDateOnContract, @CreatedBy, @CreatedOn, @Modifier, @Version, @VersionTime, @IsCurrentVersion, @ProductEmailTemplateVersionId, @ProductSLMSTemplateVersionId, @ProductPricingProductBasedId, @ProductPricingValueBasedId, @ProductExpirySchemeId, @ProductRedeemDateBlacklistId, @ProductRedeemTimeRestrictionId, @ProductExternalPropertyId, @ProductAcceptanceLoopId, @IsMultiBrand, @ShowcodeType, @DisplayText, @TXCProductPriceId,@RequireExpiryDate,@HasMultiBarcode
		END
		
		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		THROW;

	END CATCH
END
