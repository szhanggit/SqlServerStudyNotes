CREATE TABLE [dbo].[ProductCustomizedEmailTemplateVersionSet] (
    [Id]                                      INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProductCustomizedEmailTemplateVersionId] INT NOT NULL,
    [EmailTemplateVersionId]                  INT NOT NULL,
    [EmailTemplateTagValueId]                 INT NULL,
    [ClientId]                                INT NOT NULL,
    CONSTRAINT [PK_ProductCustomizedEmailTemplateVersionSet_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ProductCustomizedEmailTemplateVersionSet_Client_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([Id]),
    CONSTRAINT [FK_ProductCustomizedEmailTemplateVersionSet_EmailTemplateVersion_EmailTemplateVersionId] FOREIGN KEY ([EmailTemplateVersionId]) REFERENCES [dbo].[EmailTemplateVersion] ([Id]),
    CONSTRAINT [FK_ProductCustomizedEmailTemplateVersionSet_ProductEmailTemplateTagValue_EmailTemplateTagValueId] FOREIGN KEY ([EmailTemplateTagValueId]) REFERENCES [dbo].[ProductEmailTemplateTagValue] ([Id]),
    CONSTRAINT [FK_Set_ProductCustomizedEmailTemplateVersion_ProductCustomizedEmailTemplateVersionId] FOREIGN KEY ([ProductCustomizedEmailTemplateVersionId]) REFERENCES [dbo].[ProductCustomizedEmailTemplateVersion] ([Id])
);

