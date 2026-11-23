CREATE TABLE [dbo].[SCVTemplateHistory] (
    [Id]            INT            IDENTITY (1, 1) NOT NULL,
    [TemplateId]    INT            NULL,
    [TemplateName]  VARCHAR (100)  NOT NULL,
    [Status]        BIT            NOT NULL,
    [LanguageId]    INT            NULL,
    [Description]   NVARCHAR (500) NULL,
    [CreatedBy]     NVARCHAR (50)  NOT NULL,
    [VersionNumber] INT            NOT NULL,
    [VersionTime]   DATETIME       NOT NULL,
    CONSTRAINT [PK_SCVTemplateHistory_Id] PRIMARY KEY CLUSTERED ([Id] DESC)
);

