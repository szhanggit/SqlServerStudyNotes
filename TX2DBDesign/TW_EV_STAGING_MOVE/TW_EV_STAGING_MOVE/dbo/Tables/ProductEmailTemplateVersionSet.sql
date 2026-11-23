CREATE TABLE [dbo].[ProductEmailTemplateVersionSet] (
    [Id]                            INT IDENTITY (1, 1) NOT NULL,
    [ProductEmailTemplateVersionId] INT NULL,
    [EmailTemplateVersionId]        INT NULL,
    [EmailTemplateTagValueId]       INT NULL,
    CONSTRAINT [PK_ProductEmailTemplateVersionSet] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductEmailTemplateVersionSet_EmailTemplateVersion_EmailTemplateVersionId] FOREIGN KEY ([EmailTemplateVersionId]) REFERENCES [dbo].[EmailTemplateVersion] ([Id]),
    CONSTRAINT [FK_ProductEmailTemplateVersionSet_ProductEmailTemplateTagValue_EmailTemplateTagValueId] FOREIGN KEY ([EmailTemplateTagValueId]) REFERENCES [dbo].[ProductEmailTemplateTagValue] ([Id]),
    CONSTRAINT [FK_ProductEmailTemplateVersionSet_ProductEmailTemplateVersion_ProductEmailTemplateVersionId] FOREIGN KEY ([ProductEmailTemplateVersionId]) REFERENCES [dbo].[ProductEmailTemplateVersion] ([Id]),
    CONSTRAINT [UK_ProductEmailTemplateVersionSet] UNIQUE NONCLUSTERED ([ProductEmailTemplateVersionId] ASC, [EmailTemplateVersionId] ASC)
);

