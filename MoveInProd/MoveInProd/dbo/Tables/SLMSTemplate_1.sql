CREATE TABLE [dbo].[SLMSTemplate] (
    [Id]                INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TemplateName]      NVARCHAR (100) NOT NULL,
    [Status]            TINYINT        NOT NULL,
    [DefaultLanguageId] INT            NULL,
    CONSTRAINT [PK_SLMSTemplate] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_SLMSTemplate_Dictionary_DefaultLanguageId] FOREIGN KEY ([DefaultLanguageId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [UK_SLMSTemplate_TemplateName] UNIQUE NONCLUSTERED ([TemplateName] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1--Active
   2--Inactive', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SLMSTemplate', @level2type = N'COLUMN', @level2name = N'Status';

