CREATE TABLE [dbo].[ProductSLMSTemplateVersionSet] (
    [Id]                           INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProductSLMSTemplateVersionId] INT NULL,
    [SLMSTemplateVersionId]        INT NULL,
    [SLMSTemplateTagValueId]       INT NULL,
    CONSTRAINT [PK_ProductSLMSTemplateVersionSet] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductSLMSTemplateVersionSet_ProductSLMSTemplateTagValue_SLMSTemplateTagValueId] FOREIGN KEY ([SLMSTemplateTagValueId]) REFERENCES [dbo].[ProductSLMSTemplateTagValue] ([Id]),
    CONSTRAINT [FK_ProductSLMSTemplateVersionSet_ProductSLMSTemplateVersion_ProductSLMSTemplateVersionId] FOREIGN KEY ([ProductSLMSTemplateVersionId]) REFERENCES [dbo].[ProductSLMSTemplateVersion] ([Id]),
    CONSTRAINT [FK_ProductSLMSTemplateVersionSet_SLMSTemplateVersion_SLMSTemplateVersionId] FOREIGN KEY ([SLMSTemplateVersionId]) REFERENCES [dbo].[SLMSTemplateVersion] ([Id]),
    CONSTRAINT [UK_ProductSLMSTemplateVersionSet] UNIQUE NONCLUSTERED ([ProductSLMSTemplateVersionId] ASC, [SLMSTemplateVersionId] ASC)
);

