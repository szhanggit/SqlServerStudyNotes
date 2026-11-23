CREATE TABLE [dbo].[EmailMessageArchive] (
    [Id]             BIGINT          NOT NULL,
    [TaskId]         BIGINT          NOT NULL,
    [MessageStatus]  INT             NULL,
    [MessageLocalId] BIGINT          NOT NULL,
    [MessageSPId]    NVARCHAR (100)  NULL,
    [To]             NVARCHAR (1000) NOT NULL,
    [CC]             NVARCHAR (1000) NULL,
    [BCC]            NVARCHAR (1000) NULL,
    [Parameters]     NVARCHAR (MAX)  NULL,
    [Attachments]    NVARCHAR (1000) NULL,
    [CreatedOn]      DATETIME        NULL,
    [SentOn]         DATETIME        NULL,
    [Comment]        NVARCHAR (500)  NULL,
    [IsTracked]      BIT             DEFAULT ((0)) NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [IX_EmailMessageArchive]
    ON [dbo].[EmailMessageArchive]([Id] ASC) WITH (FILLFACTOR = 90, IGNORE_DUP_KEY = ON);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0--Initialized
   1--Sending
   2--Send Success
   3--Send Failed
   4--Trashed
   5--Unknown', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EmailMessageArchive', @level2type = N'COLUMN', @level2name = N'MessageStatus';

