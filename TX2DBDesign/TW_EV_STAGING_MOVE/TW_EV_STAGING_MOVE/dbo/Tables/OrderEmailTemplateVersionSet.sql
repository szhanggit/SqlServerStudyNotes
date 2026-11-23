CREATE TABLE [dbo].[OrderEmailTemplateVersionSet] (
    [Id]                          INT IDENTITY (1, 1) NOT NULL,
    [OrderEmailTemplateVersionId] INT NOT NULL,
    [EmailTemplateVersionId]      INT NOT NULL,
    [EmailTemplateTagValueId]     INT NULL,
    CONSTRAINT [PK_OrderEmailTemplateVersionSet] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_OrderEmailTemplateVersionSet_EmailTemplateVersion_EmailTemplateVersionId] FOREIGN KEY ([EmailTemplateVersionId]) REFERENCES [dbo].[EmailTemplateVersion] ([Id]),
    CONSTRAINT [FK_OrderEmailTemplateVersionSet_OrderEmailTemplateTagValue_EmailTemplateTagValueId] FOREIGN KEY ([EmailTemplateTagValueId]) REFERENCES [dbo].[OrderEmailTemplateTagValue] ([Id]),
    CONSTRAINT [FK_OrderEmailTemplateVersionSet_OrderEmailTemplateVersion_OrderEmailTemplateVersionId] FOREIGN KEY ([OrderEmailTemplateVersionId]) REFERENCES [dbo].[OrderEmailTemplateVersion] ([Id]),
    CONSTRAINT [UK_OrderEmailTemplateVersionSet] UNIQUE NONCLUSTERED ([OrderEmailTemplateVersionId] ASC, [EmailTemplateVersionId] ASC)
);

