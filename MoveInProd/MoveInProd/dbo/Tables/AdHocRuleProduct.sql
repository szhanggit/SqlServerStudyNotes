CREATE TABLE [dbo].[AdHocRuleProduct] (
    [Id]                            INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AdHocRuleId]                   INT NOT NULL,
    [ProductId]                     INT NOT NULL,
    [ProductEmailTemplateVersionId] INT NULL,
    [ProductSLMSTemplateVersionId]  INT NULL,
    CONSTRAINT [PK_AdHocRuleProduct] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_AdHocRuleProduct_AdHocRule_AdHocRuleId] FOREIGN KEY ([AdHocRuleId]) REFERENCES [dbo].[AdHocRule] ([Id]),
    CONSTRAINT [FK_AdHocRuleProduct_Product_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id]),
    CONSTRAINT [FK_AdHocRuleProduct_ProductEmailTemplateVersion_ProductEmailTemplateVersionId] FOREIGN KEY ([ProductEmailTemplateVersionId]) REFERENCES [dbo].[ProductEmailTemplateVersion] ([Id]),
    CONSTRAINT [FK_AdHocRuleProduct_ProductSLMSTemplateVersion_ProductSLMSTemplateVersionId] FOREIGN KEY ([ProductSLMSTemplateVersionId]) REFERENCES [dbo].[ProductSLMSTemplateVersion] ([Id]),
    CONSTRAINT [UK_AdHocRuleProduct] UNIQUE NONCLUSTERED ([AdHocRuleId] ASC, [ProductId] ASC)
);

