CREATE TABLE [dbo].[EmailTemplate] (
    [Id]                   INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TemplateName]         NVARCHAR (100) NOT NULL,
    [IsAttachmentTemplate] BIT            NOT NULL,
    [Status]               TINYINT        NOT NULL,
    [DefaultLanguageId]    INT            NULL,
    CONSTRAINT [PK_EmailTemplate] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EmailTemplate_Dictionary_DefaultLanguageId] FOREIGN KEY ([DefaultLanguageId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [UK_EmailTemplate_TemplateName] UNIQUE NONCLUSTERED ([TemplateName] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1--Active
   2--Inactive', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EmailTemplate', @level2type = N'COLUMN', @level2name = N'Status';

