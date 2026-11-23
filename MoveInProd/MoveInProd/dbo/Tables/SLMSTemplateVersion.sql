CREATE TABLE [dbo].[SLMSTemplateVersion] (
    [Id]               INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TemplateId]       INT            NOT NULL,
    [Content1]         NVARCHAR (300) NOT NULL,
    [Content2]         NVARCHAR (300) NULL,
    [Content3]         NVARCHAR (300) NULL,
    [IsCurrentVersion] BIT            NOT NULL,
    [Description]      NVARCHAR (500) NULL,
    [CreatedBy]        NVARCHAR (50)  NOT NULL,
    [Version]          INT            NOT NULL,
    [VersionTime]      DATETIME       NOT NULL,
    [LanguageId]       INT            NULL,
    CONSTRAINT [PK_SLMSTemplateVersion] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_SLMSTemplateVersion_Dictionary_LanguageId] FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [FK_SLMSTemplateVersion_SLMSTemplate_TemplateId] FOREIGN KEY ([TemplateId]) REFERENCES [dbo].[SLMSTemplate] ([Id]),
    CONSTRAINT [UK_SLMSTemplateVersion_Name_Version] UNIQUE NONCLUSTERED ([TemplateId] ASC, [Version] ASC)
);

