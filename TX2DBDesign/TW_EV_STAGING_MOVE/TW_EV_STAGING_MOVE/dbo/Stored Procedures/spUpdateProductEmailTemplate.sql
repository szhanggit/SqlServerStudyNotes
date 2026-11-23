CREATE PROCEDURE spUpdateProductEmailTemplate
	@ProductEmailContentTagValueSet ProductEmailContentTagValueSetType READONLY
	,@ProductId INT
	,@EmailTemplateVersionId INT
	,@UserName NVARCHAR(50)
	,@IsSuccess INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRAN
	BEGIN TRY


    declare @ProductEmailTemplateVersionId int, @ProductEmailTemplateTagValueId int, @ProductVersionId int, @NewProductVersionId int

  
    -- create new ProductEmailTemplateTagValue
	INSERT ProductEmailTemplateTagValue DEFAULT VALUES;
	SELECT @ProductEmailTemplateTagValueId = SCOPE_IDENTITY();
	
    -- create new ProductEmailContentTagValueSet
	insert into ProductEmailContentTagValueSet (ContentTagId, ProductEmailTemplateTagValueId, [Value], TextValue) 
	select ContentTagId, @ProductEmailTemplateTagValueId, [Value], TextValue 
	from @ProductEmailContentTagValueSet


	-- create new ProductEmailTemplateVersion
	INSERT ProductEmailTemplateVersion DEFAULT VALUES;
	SELECT @ProductEmailTemplateVersionId = SCOPE_IDENTITY();
			
	
	-- create new ProductEmailTemplateVersionSet
	insert into ProductEmailTemplateVersionSet (ProductEmailTemplateVersionId, EmailTemplateVersionId, EmailTemplateTagValueId) 
	values (@ProductEmailTemplateVersionId, @EmailTemplateVersionId, @ProductEmailTemplateTagValueId);
				
    -- update product
    update Product set ProductEmailTemplateVersionId = @ProductEmailTemplateVersionId where Id = @ProductId


	-- insert ProductVersion, refer to the new template
	
	select @ProductVersionId = Id
	from ProductVersion with(nolock) 
	where ProductId = @ProductId and IsCurrentVersion = 1
  
	insert into ProductVersion ([ProgramId], [ProductId], [ExternalProductCode], [ProductName], [Description], [Note], [EmailTemplateVersionId], 
			[EmailTemplateTagValueId], [SLMSTemplateVersionId], [SLMSTemplateTagValueId], [IsMultiBrand], [AcceptanceLoopId], [ProductPricingProductBasedId],
			[ProductPricingValueBasedId], [MinRedeemQuantity], [MaxIssuingQuantity], [ValidFrom], [ValidTo], [RedeemDateBlacklistId], [ReverseLimitId], 
			[PreAuthorizationExpiryInterval], [PreAuthorizationExpiryUnit], [RedeemTimeRestrictionId], [ProductExpirySchemeId], [UseTimeControl], 
			[UseTimeControlInterval], [MaxTotalRedeemAmountControl], [MaxTotalRedeemAmountControlInterval], [MaxSingleRedeemAmount], [ExternalPropertyId], 
			[Modifier], [Version], [VersionTime], [IsCurrentVersion], [APICacheHW], [APICacheLW], [BrandStory], [MultipleSelectionType], 
			[ProductIssuerType], [IssueMerchant], [ProductEmailTemplateVersionId], [ProductSLMSTemplateVersionId], [PinCodeType], [PinCodeLength], 
			[IsMasterProduct], [ProductComboId], [ProductTag], [AddToWallet], [ProductCategory])
	select  [ProgramId], [ProductId], [ExternalProductCode], [ProductName], [Description], [Note], [EmailTemplateVersionId], 
			[EmailTemplateTagValueId], [SLMSTemplateVersionId], [SLMSTemplateTagValueId], [IsMultiBrand], [AcceptanceLoopId], [ProductPricingProductBasedId],
			[ProductPricingValueBasedId], [MinRedeemQuantity], [MaxIssuingQuantity], [ValidFrom], [ValidTo], [RedeemDateBlacklistId], [ReverseLimitId], 
			[PreAuthorizationExpiryInterval], [PreAuthorizationExpiryUnit], [RedeemTimeRestrictionId], [ProductExpirySchemeId], [UseTimeControl], 
			[UseTimeControlInterval], [MaxTotalRedeemAmountControl], [MaxTotalRedeemAmountControlInterval], [MaxSingleRedeemAmount], [ExternalPropertyId], 
			@UserName, [Version] + 1, GETDATE(), [IsCurrentVersion], [APICacheHW], [APICacheLW], [BrandStory], [MultipleSelectionType], 
			[ProductIssuerType], [IssueMerchant],  @ProductEmailTemplateVersionId, [ProductSLMSTemplateVersionId], [PinCodeType], [PinCodeLength], 
			[IsMasterProduct], [ProductComboId], [ProductTag], [AddToWallet], [ProductCategory]
	from ProductVersion with(nolock) 
	where ProductId = @ProductId and IsCurrentVersion = 1

    set @NewProductVersionId = SCOPE_IDENTITY()
    insert into ProductPricingDynamicFaceValue ([ProductVersionId],[DefaultSellingPrice],[DefaultProductCost])
    select top 1 @NewProductVersionId,[DefaultSellingPrice],[DefaultProductCost] from ProductPricingDynamicFaceValue where ProductVersionId = @ProductVersionId

	update ProductVersion set IsCurrentVersion = 0 where Id = @ProductVersionId
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		begin
			set @IsSuccess = 0;
			ROLLBACK TRANSACTION;			
		end
	END CATCH;
	IF @@TRANCOUNT > 0
	begin
		set @IsSuccess = 1;
		COMMIT TRANSACTION;	
	end
END