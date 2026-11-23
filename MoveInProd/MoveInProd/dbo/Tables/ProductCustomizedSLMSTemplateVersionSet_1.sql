CREATE TABLE [dbo].[ProductCustomizedSLMSTemplateVersionSet] (
    [Id]                                     INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProductCustomizedSLMSTemplateVersionId] INT NOT NULL,
    [SLMSTemplateVersionId]                  INT NOT NULL,
    [SLMSTemplateTagValueId]                 INT NULL,
    [ClientId]                               INT NOT NULL,
    CONSTRAINT [PK_ProductCustomizedSLMSTemplateVersionSet_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ProductCustomizedSLMSTemplateVersionSet_Client_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([Id]),
    CONSTRAINT [FK_ProductCustomizedSLMSTemplateVersionSet_ProductSLMSTemplateTagValue_SLMSTemplateTagValueId] FOREIGN KEY ([SLMSTemplateTagValueId]) REFERENCES [dbo].[ProductSLMSTemplateTagValue] ([Id]),
    CONSTRAINT [FK_ProductCustomizedSLMSTemplateVersionSet_SLMSTemplateVersion_SLMSTemplateVersionId] FOREIGN KEY ([SLMSTemplateVersionId]) REFERENCES [dbo].[SLMSTemplateVersion] ([Id]),
    CONSTRAINT [FK_Set_ProductCustomizedSLMSTemplateVersion_ProductCustomizedSLMSTemplateVersionId] FOREIGN KEY ([ProductCustomizedSLMSTemplateVersionId]) REFERENCES [dbo].[ProductCustomizedSLMSTemplateVersion] ([Id])
);

