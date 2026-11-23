CREATE TABLE [dbo].[OrderSLMSTemplateVersionSet] (
    [Id]                         INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OrderSLMSTemplateVersionId] INT NOT NULL,
    [SLMSTemplateVersionId]      INT NOT NULL,
    [SLMSTemplateTagValueId]     INT NULL,
    CONSTRAINT [PK_OrderSLMSTemplateVersionSet] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_OrderSLMSTemplateVersionSet_OrderSLMSTemplateTagValue_SLMSTemplateTagValueId] FOREIGN KEY ([SLMSTemplateTagValueId]) REFERENCES [dbo].[OrderSLMSTemplateTagValue] ([Id]),
    CONSTRAINT [FK_OrderSLMSTemplateVersionSet_OrderSLMSTemplateVersion_OrderSLMSTemplateVersionId] FOREIGN KEY ([OrderSLMSTemplateVersionId]) REFERENCES [dbo].[OrderSLMSTemplateVersion] ([Id]),
    CONSTRAINT [FK_OrderSLMSTemplateVersionSet_SLMSTemplateVersion_SLMSTemplateVersionId] FOREIGN KEY ([SLMSTemplateVersionId]) REFERENCES [dbo].[SLMSTemplateVersion] ([Id]),
    CONSTRAINT [UK_OrderSLMSTemplateVersionSet] UNIQUE NONCLUSTERED ([OrderSLMSTemplateVersionId] ASC, [SLMSTemplateVersionId] ASC)
);

