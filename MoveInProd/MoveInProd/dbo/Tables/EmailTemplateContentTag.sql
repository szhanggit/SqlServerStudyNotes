CREATE TABLE [dbo].[EmailTemplateContentTag] (
    [Id]           INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TemplateId]   INT NOT NULL,
    [ContentTagId] INT NOT NULL,
    CONSTRAINT [PK_EmailTemplateContentTag] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EmailTemplateContentTag_ContentTag_ContentTagId] FOREIGN KEY ([ContentTagId]) REFERENCES [dbo].[ContentTag] ([Id]),
    CONSTRAINT [FK_EmailTemplateContentTag_EmailTemplate_TemplateId] FOREIGN KEY ([TemplateId]) REFERENCES [dbo].[EmailTemplateVersion] ([Id]),
    CONSTRAINT [UK_EmailTemplateContentTag_Id_Tag] UNIQUE NONCLUSTERED ([TemplateId] ASC, [ContentTagId] ASC)
);

