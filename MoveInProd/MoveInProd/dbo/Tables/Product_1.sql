CREATE TABLE [dbo].[Product] (
    [Id]                                      INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProgramId]                               INT            NOT NULL,
    [ProductCode]                             VARCHAR (50)   NOT NULL,
    [ExternalProductCode]                     VARCHAR (50)   NULL,
    [ProductName]                             NVARCHAR (200) NOT NULL,
    [Description]                             NVARCHAR (500) NULL,
    [Note]                                    NVARCHAR (MAX) NULL,
    [VoucherNumberGenerateWay]                TINYINT        NOT NULL,
    [VoucherNumberRuleId]                     INT            NULL,
    [EmailTemplateVersionId]                  INT            NULL,
    [EmailTemplateTagValueId]                 INT            NULL,
    [SLMSTemplateVersionId]                   INT            NULL,
    [SLMSTemplateTagValueId]                  INT            NULL,
    [IsMultiBrand]                            BIT            DEFAULT ((0)) NOT NULL,
    [AcceptanceLoopId]                        INT            NOT NULL,
    [ProductType]                             TINYINT        NOT NULL,
    [CanTopup]                                BIT            DEFAULT ((0)) NOT NULL,
    [MinRedeemQuantity]                       INT            NOT NULL,
    [MaxIssuingQuantity]                      INT            NULL,
    [ValidFrom]                               DATETIME       NOT NULL,
    [ValidTo]                                 DATETIME       NOT NULL,
    [RedeemDateBlacklistId]                   INT            NULL,
    [ReverseLimitId]                          INT            NOT NULL,
    [PreAuthorizationExpiryInterval]          INT            NOT NULL,
    [PreAuthorizationExpiryUnit]              TINYINT        NOT NULL,
    [RedeemTimeRestrictionId]                 INT            NULL,
    [ProductExpirySchemeId]                   INT            NOT NULL,
    [UseTimeControl]                          SMALLINT       NOT NULL,
    [UseTimeControlInterval]                  SMALLINT       NOT NULL,
    [MaxTotalRedeemAmountControl]             INT            NOT NULL,
    [MaxTotalRedeemAmountControlInterval]     SMALLINT       NOT NULL,
    [MaxSingleRedeemAmount]                   INT            NOT NULL,
    [ExternalPropertyId]                      INT            NULL,
    [Status]                                  TINYINT        NOT NULL,
    [CreatedBy]                               NVARCHAR (50)  NOT NULL,
    [CreatedOn]                               DATETIME       NOT NULL,
    [ExpirationDate]                          DATETIME       NULL,
    [APICacheHW]                              INT            NULL,
    [APICacheLW]                              INT            NULL,
    [BrandStory]                              NVARCHAR (500) NULL,
    [CanIssue]                                BIT            NOT NULL,
    [StopIssueTime]                           DATETIME       NULL,
    [VoucherImportTemplateId]                 INT            NOT NULL,
    [ReminderId]                              INT            NOT NULL,
    [ProductCustomizedEmailTemplateVersionId] INT            NULL,
    [ProductCustomizedSLMSTemplateVersionId]  INT            NULL,
    [VoucherSupplierId]                       INT            NULL,
    [MultipleSelectionType]                   TINYINT        NULL,
    [ProductIssuerType]                       TINYINT        NULL,
    [IssueMerchant]                           INT            NULL,
    [RequireExpiryDate]                       BIT            NOT NULL,
    [ProductEmailTemplateVersionId]           INT            NULL,
    [ProductSLMSTemplateVersionId]            INT            NULL,
    [PinCodeType]                             TINYINT        NULL,
    [PinCodeLength]                           TINYINT        NULL,
    [IsMasterProduct]                         BIT            NOT NULL,
    [ProductComboId]                          INT            NULL,
    [MerchantAcquirerId]                      INT            NULL,
    [ProductTag]                              INT            NULL,
    [AddToWallet]                             BIT            DEFAULT ((0)) NOT NULL,
    [ProductSubType]                          INT            NULL,
    [BrandId]                                 INT            NULL,
    CONSTRAINT [PK_PRODUCT] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Product_AcceptanceLoop_AcceptanceLoopId] FOREIGN KEY ([AcceptanceLoopId]) REFERENCES [dbo].[AcceptanceLoop] ([Id]),
    CONSTRAINT [FK_Product_Brand_BrandId] FOREIGN KEY ([BrandId]) REFERENCES [dbo].[Brand] ([Id]),
    CONSTRAINT [FK_Product_Dictionary_ReminderId] FOREIGN KEY ([ReminderId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [FK_Product_EmailTemplateVersion_EmailTemplateVersionId] FOREIGN KEY ([EmailTemplateVersionId]) REFERENCES [dbo].[EmailTemplateVersion] ([Id]),
    CONSTRAINT [FK_Product_ProductCombo_ProductComboId] FOREIGN KEY ([ProductComboId]) REFERENCES [dbo].[ProductCombo] ([Id]),
    CONSTRAINT [FK_Product_ProductCustomizedEmailTemplateVersion_ProductCustomizedEmailTemplateVersionId] FOREIGN KEY ([ProductCustomizedEmailTemplateVersionId]) REFERENCES [dbo].[ProductCustomizedEmailTemplateVersion] ([Id]),
    CONSTRAINT [FK_Product_ProductCustomizedSLMSTemplateVersion_ProductCustomizedSLMSTemplateVersionId] FOREIGN KEY ([ProductCustomizedSLMSTemplateVersionId]) REFERENCES [dbo].[ProductCustomizedSLMSTemplateVersion] ([Id]),
    CONSTRAINT [FK_Product_ProductEmailTemplateTagValue_EmailTemplateTagValueId] FOREIGN KEY ([EmailTemplateTagValueId]) REFERENCES [dbo].[ProductEmailTemplateTagValue] ([Id]),
    CONSTRAINT [FK_Product_ProductEmailTemplateVersion_ProductEmailTemplateVersionId] FOREIGN KEY ([ProductEmailTemplateVersionId]) REFERENCES [dbo].[ProductEmailTemplateVersion] ([Id]),
    CONSTRAINT [FK_Product_ProductExpiryScheme_ProductExpirySchemeId] FOREIGN KEY ([ProductExpirySchemeId]) REFERENCES [dbo].[ProductExpiryScheme] ([Id]),
    CONSTRAINT [FK_Product_ProductExternalProperty_ExternalPropertyId] FOREIGN KEY ([ExternalPropertyId]) REFERENCES [dbo].[ProductExternalProperty] ([Id]),
    CONSTRAINT [FK_Product_ProductRedeemDateBlacklist_RedeemDateBlacklistId] FOREIGN KEY ([RedeemDateBlacklistId]) REFERENCES [dbo].[ProductRedeemDateBlacklist] ([Id]),
    CONSTRAINT [FK_Product_ProductRedeemTimeRestriction_RedeemTimeRestrictionId] FOREIGN KEY ([RedeemTimeRestrictionId]) REFERENCES [dbo].[ProductRedeemTimeRestriction] ([Id]),
    CONSTRAINT [FK_Product_ProductSLMSTemplateTagValue_SLMSTemplateTagValueId] FOREIGN KEY ([SLMSTemplateTagValueId]) REFERENCES [dbo].[ProductSLMSTemplateTagValue] ([Id]),
    CONSTRAINT [FK_Product_ProductSLMSTemplateVersion_ProductSLMSTemplateVersionId] FOREIGN KEY ([ProductSLMSTemplateVersionId]) REFERENCES [dbo].[ProductSLMSTemplateVersion] ([Id]),
    CONSTRAINT [FK_Product_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([Id]),
    CONSTRAINT [FK_Product_ReverseLimit_ReverseLimitId] FOREIGN KEY ([ReverseLimitId]) REFERENCES [dbo].[ReverseLimit] ([Id]),
    CONSTRAINT [FK_Product_SLMSTemplateVersion_SLMSTemplateVersionId] FOREIGN KEY ([SLMSTemplateVersionId]) REFERENCES [dbo].[SLMSTemplateVersion] ([Id]),
    CONSTRAINT [FK_Product_VoucherImportTemplate_VoucherImportTemplateId] FOREIGN KEY ([VoucherImportTemplateId]) REFERENCES [dbo].[VoucherImportTemplate] ([Id]),
    CONSTRAINT [FK_Product_VoucherNumberRule_VoucherNumberRuleId] FOREIGN KEY ([VoucherNumberRuleId]) REFERENCES [dbo].[VoucherNumberRule] ([Id]),
    CONSTRAINT [FK_Product_VoucherSupplier_VoucherSupplierId] FOREIGN KEY ([VoucherSupplierId]) REFERENCES [dbo].[VoucherSupplier] ([Id]),
    CONSTRAINT [UK_Product_ProductCode] UNIQUE NONCLUSTERED ([ProductCode] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1--Edenred
   2--Third party', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Product', @level2type = N'COLUMN', @level2name = N'VoucherNumberGenerateWay';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1--product based
   2--Value based', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Product', @level2type = N'COLUMN', @level2name = N'ProductType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The unit is day', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Product', @level2type = N'COLUMN', @level2name = N'UseTimeControlInterval';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'the unit is day', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Product', @level2type = N'COLUMN', @level2name = N'MaxTotalRedeemAmountControlInterval';

