CREATE TABLE [dbo].[EmailMessage] (
    [Id]             BIGINT          IDENTITY (1, 1) NOT NULL,
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
    [IsTracked]      BIT             DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_MessageEmail] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EmailMessage_Task_TaskId] FOREIGN KEY ([TaskId]) REFERENCES [dbo].[Task] ([Id]),
    CONSTRAINT [UK_EmailMessage_TaskId_MessageLocalId] UNIQUE NONCLUSTERED ([TaskId] ASC, [MessageLocalId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_EmailMessage_MessageStatus]
    ON [dbo].[EmailMessage]([MessageStatus] ASC);


GO
CREATE NONCLUSTERED INDEX [index_EmailMessage_SentOn]
    ON [dbo].[EmailMessage]([SentOn] DESC);


GO
CREATE NONCLUSTERED INDEX [index_EmailMessage_MessageSPId]
    ON [dbo].[EmailMessage]([MessageSPId] DESC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '    Initialized = 1,
       Sending = 2,
       SentSuccess = 3,
       SentFailed = 4,
       ToBeResent = 5,
       Trashed = 6,
       Unknown = 7', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EmailMessage', @level2type = N'COLUMN', @level2name = N'MessageStatus';

