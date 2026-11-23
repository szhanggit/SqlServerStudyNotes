CREATE PROCEDURE [spInsProductExpirationPolicy]
		 @TXCProductId int
		 ,@UserName varchar(100)
		 ,@TenantId int
		 ,@ProductExpirationPolicy SingleListType Readonly
		 ,@Result int output
AS
BEGIN
	SET XACT_ABORT ON;
	Declare @version int = 0;
	Declare @ProductPricingProductBasedId int;
	Declare @ProductPricingValueBasedId int;
	Declare @ProductExpirySchemeId int;
    BEGIN TRY

        BEGIN TRANSACTION;       
		
		INSERT ProductExpiryScheme DEFAULT VALUES;	
		set @ProductExpirySchemeId = SCOPE_IDENTITY();

		insert into ProductExpirySchemeSet (ProductExpirySchemeId, ExpirationPolicyId)
		select @ProductExpirySchemeId as ProductExpirySchemeId, Id as ExpirationPolicyId from @ProductExpirationPolicy

		select @version = pv.[Version]
		, @ProductPricingProductBasedId = pv.ProductPricingProductBasedId
		, @ProductPricingValueBasedId = pv.ProductPricingValueBasedId
		from Product p with(nolock)
		inner join ProductVersion pv with(nolock) on p.Id = pv.ProductId
		inner join TXCProductMapping map with(nolock) on map.ProductId = p.Id
		where map.ExternalId = @TXCProductId AND pv.IsCurrentVersion = 1

		update pv
		set pv.IsCurrentVersion = 0
		from Product p with(nolock)
		inner join ProductVersion pv with(nolock) on p.Id = pv.ProductId
		inner join TXCProductMapping map with(nolock) on map.ProductId = p.Id
		where map.ExternalId = @TXCProductId AND pv.IsCurrentVersion = 1

		update p
		set p.ProductExpirySchemeId = @ProductExpirySchemeId
		from Product p with(nolock)
		inner join TXCProductMapping map with(nolock) on map.ProductId = p.Id
		where map.ExternalId = @TXCProductId

		INSERT INTO ProductVersion(ProgramId,
			ProductId,
			ExternalProductCode,
			ProductName,
			[Description],
			Note,
			EmailTemplateVersionId,
			EmailTemplateTagValueId,
			SLMSTemplateVersionId,
			SLMSTemplateTagValueId,
			IsMultiBrand,
			AcceptanceLoopId,
			ProductPricingProductBasedId,
			ProductPricingValueBasedId,
			MinRedeemQuantity,
			MaxIssuingQuantity,
			ValidFrom,
			ValidTo,
			RedeemDateBlacklistId,
			ReverseLimitId,
			PreAuthorizationExpiryInterval,
			PreAuthorizationExpiryUnit,
			RedeemTimeRestrictionId,
			ProductExpirySchemeId,
			UseTimeControl,
			UseTimeControlInterval,
			MaxTotalRedeemAmountControl,
			MaxTotalRedeemAmountControlInterval,
			MaxSingleRedeemAmount,
			ExternalPropertyId,
			Modifier,
			[Version],
			VersionTime,
			IsCurrentVersion,
			APICacheHW,
			APICacheLW,
			BrandStory,
			MultipleSelectionType,
			ProductIssuerType,
			IssueMerchant,
			ProductEmailTemplateVersionId,
			ProductSLMSTemplateVersionId,
			PinCodeType,
			PinCodeLength,
			IsMasterProduct,
			ProductComboId,
			ProductTag,
			AddToWallet
		)
		SELECT p.ProgramId,
			p.Id,
			p.ExternalProductCode,
			p.ProductName,
			p.[Description],
			p.Note,
			p.EmailTemplateVersionId,
			p.EmailTemplateTagValueId,
			p.SLMSTemplateVersionId,
			p.SLMSTemplateTagValueId,
			p.IsMultiBrand,
			p.AcceptanceLoopId,
			@ProductPricingProductBasedId as ProductPricingProductBasedId,
			@ProductPricingValueBasedId as ProductPricingValueBasedId,
			p.MinRedeemQuantity,
			p.MaxIssuingQuantity,
			p.ValidFrom,
			p.ValidTo,
			p.RedeemDateBlacklistId,
			p.ReverseLimitId,
			p.PreAuthorizationExpiryInterval,
			p.PreAuthorizationExpiryUnit,
			p.RedeemTimeRestrictionId,
			p.ProductExpirySchemeId,
			p.UseTimeControl,
			p.UseTimeControlInterval,
			p.MaxTotalRedeemAmountControl,
			p.MaxTotalRedeemAmountControlInterval,
			p.MaxSingleRedeemAmount,			
			p.ExternalPropertyId,			
			@UserName as Modifier,
			(@version + 1) as [Version],
			getdate(),
			1 as IsCurrentVersion,
			p.APICacheHW,
			p.APICacheLW,
			p.BrandStory,
			p.MultipleSelectionType,
			p.ProductIssuerType,
			p.IssueMerchant,
			p.ProductEmailTemplateVersionId,
			p.ProductSLMSTemplateVersionId,
			p.PinCodeType,
			p.PinCodeLength,
			p.IsMasterProduct,
			p.ProductComboId,
			p.ProductTag,
			p.AddToWallet 
		from Product p with(nolock)
		inner join TXCProductMapping map with(nolock) on map.ProductId = p.Id
		where map.ExternalId = @TXCProductId

		set @Result = 1;
		
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH 
	   set @Result = -1;
       IF @@TRANCOUNT  > 0
       BEGIN
          ROLLBACK TRANSACTION		  
       END;

	   THROW;
    END CATCH;

    SET NOCOUNT, XACT_ABORT OFF;
END

