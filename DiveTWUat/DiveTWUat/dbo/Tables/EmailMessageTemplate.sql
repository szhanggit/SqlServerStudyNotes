CREATE TABLE [dbo].[EmailMessageTemplate] (
    [Id]                BIGINT         IDENTITY (1, 1) NOT NULL,
    [Subject]           NVARCHAR (200) NOT NULL,
    [Body]              NVARCHAR (MAX) NOT NULL,
    [BodyFormat]        INT            NOT NULL,
    [Sender]            NVARCHAR (100) NOT NULL,
    [SenderDisplayName] NVARCHAR (100) NULL,
    CONSTRAINT [PK_MessageEmailTemplate] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--text
   2--html', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EmailMessageTemplate', @level2type = N'COLUMN', @level2name = N'BodyFormat';

