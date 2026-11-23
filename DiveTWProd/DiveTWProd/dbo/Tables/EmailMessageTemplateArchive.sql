CREATE TABLE [dbo].[EmailMessageTemplateArchive] (
    [Id]                BIGINT         NOT NULL,
    [Subject]           NVARCHAR (200) NOT NULL,
    [Body]              NVARCHAR (MAX) NOT NULL,
    [BodyFormat]        INT            NOT NULL,
    [Sender]            NVARCHAR (100) NOT NULL,
    [SenderDisplayName] NVARCHAR (100) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [IX_EmailMessageTemplateArchive]
    ON [dbo].[EmailMessageTemplateArchive]([Id] ASC) WITH (FILLFACTOR = 90, IGNORE_DUP_KEY = ON);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--text
   2--html', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EmailMessageTemplateArchive', @level2type = N'COLUMN', @level2name = N'BodyFormat';

