CREATE TABLE [dbo].[SCVTemplate] (
    [Id]            INT            IDENTITY (1, 1) NOT NULL,
    [TemplateName]  VARCHAR (100)  NOT NULL,
    [Status]        BIT            NOT NULL,
    [LanguageId]    INT            NULL,
    [Description]   NVARCHAR (500) NULL,
    [CreatedBy]     NVARCHAR (50)  NOT NULL,
    [VersionNumber] INT            NOT NULL,
    [VersionTime]   DATETIME       NOT NULL,
    CONSTRAINT [PK_SCVTemplate_Id] PRIMARY KEY CLUSTERED ([Id] DESC),
    CONSTRAINT [FK_SCVTemplate_Dictionary_LanguageId] FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Dictionary] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [Index_SCVTemplate_TemplateName]
    ON [dbo].[SCVTemplate]([TemplateName] ASC);

