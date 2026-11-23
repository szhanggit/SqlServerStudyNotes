
CREATE PROCEDURE dbo.spUpd_ProductPricingProductBased  
@ProductCode VARCHAR(50),  
@CostWithTax NUMERIC (15, 4)
AS  
BEGIN
SET NOCOUNT ON


	BEGIN TRAN

	BEGIN TRY

------------------------------------------------------------
		DECLARE @pppbID INT,
				@pvID INT

		INSERT INTO ProductPricingProductBased (FaceValue
			,SellingPricePrepaid
			,SellingPricePostpaid
			,Cost
			,FaceValueWithTax
			,SellingPricePrepaidWithTax
			,SellingPricePostpaidWithTax
			,CostWithTax
			,Balance)
		SELECT pppb.FaceValue
			,pppb.SellingPricePrepaid
			,pppb.SellingPricePostpaid
			,round(@CostWithTax/1.05, 4)
			,pppb.FaceValueWithTax
			,pppb.SellingPricePrepaidWithTax
			,pppb.SellingPricePostpaidWithTax
			,@CostWithTax 
			,pppb.Balance
		FROM Product p with(nolock)
		INNER JOIN ProductVersion pv with(nolock) on p.Id = pv.ProductId
		INNER JOIN ProductPricingProductBased pppb with(nolock) on pv.ProductPricingProductBasedId = pppb.Id
		WHERE p.ProductCode = @ProductCode AND pv.IsCurrentVersion = 1

		SELECT @pppbID = SCOPE_IDENTITY()

		SELECT @pvID = pv.Id
		FROM Product p with(nolock)
		INNER JOIN ProductVersion pv with(nolock) on p.Id = pv.ProductId
		WHERE p.ProductCode = @ProductCode and pv.IsCurrentVersion = 1

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
		SELECT pv.ProgramId,
			pv.ProductId,
			pv.ExternalProductCode,
			pv.ProductName,
			pv.[Description],
			pv.Note,
			pv.EmailTemplateVersionId,
			pv.EmailTemplateTagValueId,
			pv.SLMSTemplateVersionId,
			pv.SLMSTemplateTagValueId,
			pv.IsMultiBrand,
			pv.AcceptanceLoopId,
			@pppbID,
			pv.ProductPricingValueBasedId,
			pv.MinRedeemQuantity,
			pv.MaxIssuingQuantity,
			pv.ValidFrom,
			pv.ValidTo,
			pv.RedeemDateBlacklistId,
			pv.ReverseLimitId,
			pv.PreAuthorizationExpiryInterval,
			pv.PreAuthorizationExpiryUnit,
			pv.RedeemTimeRestrictionId,
			pv.ProductExpirySchemeId,
			pv.UseTimeControl,
			pv.UseTimeControlInterval,
			pv.MaxTotalRedeemAmountControl,
			pv.MaxTotalRedeemAmountControlInterval,
			pv.MaxSingleRedeemAmount,
			pv.ExternalPropertyId,
			'Support' as Modifier,
			pv.[Version] + 1,
			getdate(),
			pv.IsCurrentVersion,
			pv.APICacheHW,
			pv.APICacheLW,
			pv.BrandStory,
			pv.MultipleSelectionType,
			pv.ProductIssuerType,
			pv.IssueMerchant,
			pv.ProductEmailTemplateVersionId,
			pv.ProductSLMSTemplateVersionId,
			pv.PinCodeType,
			pv.PinCodeLength,
			pv.IsMasterProduct,
			pv.ProductComboId,
			pv.ProductTag,
			pv.AddToWallet 
		FROM Product p with(nolock)
		INNER JOIN ProductVersion pv with(nolock) on p.Id = pv.ProductId
		WHERE p.ProductCode = @ProductCode and pv.IsCurrentVersion = 1

		UPDATE pv
		SET pv.IsCurrentVersion = 0
		FROM Product p with(nolock)
		INNER JOIN ProductVersion pv with(nolock) on p.Id = pv.ProductId
		WHERE p.ProductCode = @ProductCode and pv.IsCurrentVersion = 1 and pv.Id = @pvID

		
------------------------------------------------------------
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;
	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
		
END		
