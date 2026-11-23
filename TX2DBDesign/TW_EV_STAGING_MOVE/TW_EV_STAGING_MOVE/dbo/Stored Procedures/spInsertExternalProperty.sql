
  
CREATE PROCEDURE [spInsertExternalProperty]  
    @TXCProductId int  
   ,@TenantId int  
   ,@UserName nvarchar(250)   
   ,@ProductExternalPropertyList ProductExternalPropertySetType Readonly  
   ,@Result int output  
AS  
BEGIN  
 SET XACT_ABORT ON;  
  
    BEGIN TRY  
  
    BEGIN TRANSACTION;         
  declare @version int = 0;  
  declare @ProductPricingProductBasedId int;  
  declare @ProductPricingValueBasedId int;  
  INSERT ProductExternalProperty DEFAULT VALUES;   
  Declare @ProductExternalPropertyId int = SCOPE_IDENTITY();  
  insert into ProductExternalPropertySet (ProductExternalPropertyId, PropertyName, PropertyValue, [Description])  
  select @ProductExternalPropertyId as ProductExternalPropertyId  
  , PropertyName  
  , PropertyValue  
  , [Description]   
  from @ProductExternalPropertyList  
  
  select @version = pv.[Version]  
  , @ProductPricingProductBasedId = pv.ProductPricingProductBasedId  
  , @ProductPricingValueBasedId = pv.ProductPricingValueBasedId  
  from Product p with(nolock)  
  inner join [dbo].[TXCProductMapping] m with(nolock) on p.Id = m.ProductId  
  inner join ProductVersion pv with(nolock) on p.Id = pv.ProductId  
  where m.TXCTenantId = @TenantId AND m.ExternalId = @TXCProductId AND pv.IsCurrentVersion = 1  
  
  update pv  
  set pv.IsCurrentVersion = 0  
  from Product p with(nolock)  
  inner join [dbo].[TXCProductMapping] m with(nolock) on p.Id = m.ProductId  
  inner join ProductVersion pv with(nolock) on p.Id = pv.ProductId  
  where m.TXCTenantId = @TenantId AND m.ExternalId = @TXCProductId AND pv.IsCurrentVersion = 1  
  
  
  update p  
  set p.ExternalPropertyId = @ProductExternalPropertyId  
  from Product p with(nolock)  
  inner join [dbo].[TXCProductMapping] m with(nolock) on p.Id = m.ProductId  
  where m.TXCTenantId = @TenantId AND m.ExternalId = @TXCProductId  
  
  
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
   @ProductExternalPropertyId as ExternalPropertyId,     
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
  inner join [dbo].[TXCProductMapping] m with(nolock) on p.Id = m.ProductId  
  where m.TXCTenantId = @TenantId AND m.ExternalId = @TXCProductId  
   
    
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

