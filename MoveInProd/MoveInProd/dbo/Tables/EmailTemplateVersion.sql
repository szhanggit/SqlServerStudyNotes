CREATE TABLE [dbo].[EmailTemplateVersion] (
    [Id]                   INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AttachmentTemplateId] INT            NULL,
    [TemplateId]           INT            NOT NULL,
    [Subject]              NVARCHAR (500) NOT NULL,
    [Content]              NVARCHAR (MAX) NOT NULL,
    [IsCurrentVersion]     BIT            NOT NULL,
    [Description]          NVARCHAR (500) NULL,
    [CreatedBy]            NVARCHAR (50)  NOT NULL,
    [Version]              INT            NOT NULL,
    [VersionTime]          DATETIME       NOT NULL,
    [LanguageId]           INT            NULL,
    CONSTRAINT [PK_EmailTemplateVersion] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EmailTemplate_EmailTemplate_AttachmentTemplateId] FOREIGN KEY ([AttachmentTemplateId]) REFERENCES [dbo].[EmailTemplateVersion] ([Id]),
    CONSTRAINT [FK_EmailTemplateVersion_Dictionary_LanguageId] FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [FK_EmailTemplateVersion_EmailTemplate_TemplateId] FOREIGN KEY ([TemplateId]) REFERENCES [dbo].[EmailTemplate] ([Id]),
    CONSTRAINT [UK_EmailTemplateVersion_TemplateName_Version] UNIQUE NONCLUSTERED ([TemplateId] ASC, [Version] ASC)
);

