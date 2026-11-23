CREATE TABLE [dbo].[SLMSMessage] (
    [Id]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [TaskId]         BIGINT         NOT NULL,
    [MessageStatus]  INT            NULL,
    [MessageLocalId] BIGINT         NOT NULL,
    [MessageSPId]    NVARCHAR (100) NULL,
    [MobilePhone]    NVARCHAR (20)  NOT NULL,
    [Parameters]     NVARCHAR (MAX) NULL,
    [CreatedOn]      DATETIME       NULL,
    [SentOn]         DATETIME       NULL,
    [Comment]        NVARCHAR (500) NULL,
    [IsTracked]      BIT            CONSTRAINT [DF__SLMSMessa__IsTra__0D84EF7E] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_MessageSLMS] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_SLMSMessage_Task_TaskId] FOREIGN KEY ([TaskId]) REFERENCES [dbo].[Task] ([Id]),
    CONSTRAINT [UK_SLMSMessage_TaskId_MessageLocalId] UNIQUE NONCLUSTERED ([TaskId] ASC, [MessageLocalId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_SLMSMessage_MessageStatus]
    ON [dbo].[SLMSMessage]([MessageStatus] ASC);


GO
CREATE NONCLUSTERED INDEX [index_SLMSMessage_SentOn]
    ON [dbo].[SLMSMessage]([SentOn] DESC);


GO
CREATE NONCLUSTERED INDEX [index_SLMSMessage_MessageSPId]
    ON [dbo].[SLMSMessage]([MessageSPId] DESC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '    Initialized = 1,
       Sending = 2,
       SentSuccess = 3,
       SentFailed = 4,
       ToBeResent = 5,
       Trashed = 6,
       Unknown = 7', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SLMSMessage', @level2type = N'COLUMN', @level2name = N'MessageStatus';

