CREATE TABLE [dbo].[ProductVersion] (
    [Id]                                  INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProgramId]                           INT            NOT NULL,
    [ProductId]                           INT            NOT NULL,
    [ExternalProductCode]                 VARCHAR (50)   NULL,
    [ProductName]                         NVARCHAR (200) NOT NULL,
    [Description]                         NVARCHAR (500) NULL,
    [Note]                                NVARCHAR (MAX) NULL,
    [EmailTemplateVersionId]              INT            NULL,
    [EmailTemplateTagValueId]             INT            NULL,
    [SLMSTemplateVersionId]               INT            NULL,
    [SLMSTemplateTagValueId]              INT            NULL,
    [IsMultiBrand]                        BIT            NOT NULL,
    [AcceptanceLoopId]                    INT            NOT NULL,
    [ProductPricingProductBasedId]        INT            NULL,
    [ProductPricingValueBasedId]          INT            NULL,
    [MinRedeemQuantity]                   INT            DEFAULT ((0)) NOT NULL,
    [MaxIssuingQuantity]                  INT            DEFAULT ((0)) NULL,
    [ValidFrom]                           DATETIME       NOT NULL,
    [ValidTo]                             DATETIME       NOT NULL,
    [RedeemDateBlacklistId]               INT            NULL,
    [ReverseLimitId]                      INT            NOT NULL,
    [PreAuthorizationExpiryInterval]      INT            NOT NULL,
    [PreAuthorizationExpiryUnit]          TINYINT        NOT NULL,
    [RedeemTimeRestrictionId]             INT            NULL,
    [ProductExpirySchemeId]               INT            NOT NULL,
    [UseTimeControl]                      SMALLINT       NOT NULL,
    [UseTimeControlInterval]              SMALLINT       NOT NULL,
    [MaxTotalRedeemAmountControl]         INT            NOT NULL,
    [MaxTotalRedeemAmountControlInterval] SMALLINT       NOT NULL,
    [MaxSingleRedeemAmount]               INT            NOT NULL,
    [ExternalPropertyId]                  INT            NULL,
    [Modifier]                            NVARCHAR (50)  NOT NULL,
    [Version]                             INT            NOT NULL,
    [VersionTime]                         DATETIME       NOT NULL,
    [IsCurrentVersion]                    BIT            NOT NULL,
    [APICacheHW]                          INT            NULL,
    [APICacheLW]                          INT            NULL,
    [BrandStory]                          NVARCHAR (500) NULL,
    [MultipleSelectionType]               TINYINT        NULL,
    [ProductIssuerType]                   TINYINT        NULL,
    [IssueMerchant]                       INT            NULL,
    [ProductEmailTemplateVersionId]       INT            NULL,
    [ProductSLMSTemplateVersionId]        INT            NULL,
    [PinCodeType]                         TINYINT        NULL,
    [PinCodeLength]                       TINYINT        NULL,
    [IsMasterProduct]                     BIT            NOT NULL,
    [ProductComboId]                      INT            NULL,
    [ProductTag]                          INT            NULL,
    [AddToWallet]                         BIT            DEFAULT ((0)) NOT NULL,
    [ProductCategory]                     INT            NULL,
    [CanExtend]                           BIT            DEFAULT ((0)) NOT NULL,
    [ExtensionSchemeId]                   INT            NULL,
    [MaxExtendTimes]                      INT            NULL,
    [ExtensionEndDate]                    DATETIME       NULL,
    [SameAsValidEndDateOnContract]        BIT            NULL,
    CONSTRAINT [PK_PRODUCTVERSION] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductVersion_AcceptanceLoop_AcceptanceLoopId] FOREIGN KEY ([AcceptanceLoopId]) REFERENCES [dbo].[AcceptanceLoop] ([Id]),
    CONSTRAINT [FK_ProductVersion_EmailTemplateVersion_EmailTemplateVersionId] FOREIGN KEY ([EmailTemplateVersionId]) REFERENCES [dbo].[EmailTemplateVersion] ([Id]),
    CONSTRAINT [FK_productversion_ExtensionScheme] FOREIGN KEY ([ExtensionSchemeId]) REFERENCES [dbo].[ExtensionScheme] ([Id]),
    CONSTRAINT [FK_ProductVersion_Product_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id]),
    CONSTRAINT [FK_ProductVersion_ProductCombo_ProductComboId] FOREIGN KEY ([ProductComboId]) REFERENCES [dbo].[ProductCombo] ([Id]),
    CONSTRAINT [FK_ProductVersion_ProductEmailTemplateTagValue_EmailTemplateTagValueId] FOREIGN KEY ([EmailTemplateTagValueId]) REFERENCES [dbo].[ProductEmailTemplateTagValue] ([Id]),
    CONSTRAINT [FK_ProductVersion_ProductEmailTemplateVersion_ProductEmailTemplateVersionId] FOREIGN KEY ([ProductEmailTemplateVersionId]) REFERENCES [dbo].[ProductEmailTemplateVersion] ([Id]),
    CONSTRAINT [FK_ProductVersion_ProductExpiryScheme_ProductExpirySchemeId] FOREIGN KEY ([ProductExpirySchemeId]) REFERENCES [dbo].[ProductExpiryScheme] ([Id]),
    CONSTRAINT [FK_ProductVersion_ProductExternalProperty_ExternalPropertyId] FOREIGN KEY ([ExternalPropertyId]) REFERENCES [dbo].[ProductExternalProperty] ([Id]),
    CONSTRAINT [FK_ProductVersion_ProductPricingProductBased_ProductPricingProductBasedId] FOREIGN KEY ([ProductPricingProductBasedId]) REFERENCES [dbo].[ProductPricingProductBased] ([Id]),
    CONSTRAINT [FK_ProductVersion_ProductPricingValueBased_ProductPricingValueBasedId] FOREIGN KEY ([ProductPricingValueBasedId]) REFERENCES [dbo].[ProductPricingValueBased] ([Id]),
    CONSTRAINT [FK_ProductVersion_ProductRedeemDateBlacklist_RedeemDateBlacklistId] FOREIGN KEY ([RedeemDateBlacklistId]) REFERENCES [dbo].[ProductRedeemDateBlacklist] ([Id]),
    CONSTRAINT [FK_ProductVersion_ProductRedeemTimeRestriction_RedeemTimeRestrictionId] FOREIGN KEY ([RedeemTimeRestrictionId]) REFERENCES [dbo].[ProductRedeemTimeRestriction] ([Id]),
    CONSTRAINT [FK_ProductVersion_ProductSLMSTemplateTagValue_SLMSTemplateTagValueId] FOREIGN KEY ([SLMSTemplateTagValueId]) REFERENCES [dbo].[ProductSLMSTemplateTagValue] ([Id]),
    CONSTRAINT [FK_ProductVersion_ProductSLMSTemplateVersion_ProductSLMSTemplateVersionId] FOREIGN KEY ([ProductSLMSTemplateVersionId]) REFERENCES [dbo].[ProductSLMSTemplateVersion] ([Id]),
    CONSTRAINT [FK_ProductVersion_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([Id]),
    CONSTRAINT [FK_ProductVersion_ReverseLimit_ReverseLimitId] FOREIGN KEY ([ReverseLimitId]) REFERENCES [dbo].[ReverseLimit] ([Id]),
    CONSTRAINT [FK_ProductVersion_SLMSTemplateVersion_SLMSTemplateVersionId] FOREIGN KEY ([SLMSTemplateVersionId]) REFERENCES [dbo].[SLMSTemplateVersion] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_ProductVersion_Id_ProductPricingProductBasedId_ProductPricingValueBasedId]
    ON [dbo].[ProductVersion]([Id] ASC, [ProductPricingProductBasedId] ASC, [ProductPricingValueBasedId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_ProductVersion_ProductId]
    ON [dbo].[ProductVersion]([ProductId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_ProductVersion_ProductPricingProductBasedId]
    ON [dbo].[ProductVersion]([ProductPricingProductBasedId] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_ProductVersion_ProductPricingValueBasedId]
    ON [dbo].[ProductVersion]([ProductPricingValueBasedId] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--Alwary can reversed
   2--within 24 hours
   3--within 1 week
   4--within 1 month', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductVersion', @level2type = N'COLUMN', @level2name = N'ReverseLimitId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '5--Day
   6--Week
   7--Month', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductVersion', @level2type = N'COLUMN', @level2name = N'PreAuthorizationExpiryUnit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'The unit is day', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductVersion', @level2type = N'COLUMN', @level2name = N'UseTimeControlInterval';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'the unit is day', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductVersion', @level2type = N'COLUMN', @level2name = N'MaxTotalRedeemAmountControlInterval';

