CREATE TABLE [dbo].[EmailMessagePartTwo] (
    [Id]             BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EmailMessageId] BIGINT         NOT NULL,
    [MessageStatus]  INT            NULL,
    [MessageLocalId] BIGINT         NOT NULL,
    [MessageSPId]    NVARCHAR (100) NULL,
    [Parameters]     NVARCHAR (MAX) NULL,
    [CreatedOn]      DATETIME       NULL,
    [SentOn]         DATETIME       NULL,
    [Comment]        NVARCHAR (500) NULL,
    CONSTRAINT [PK_MessageEmailPartTwo] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EmailMessagePartTwo_EmailMessage_Id] FOREIGN KEY ([EmailMessageId]) REFERENCES [dbo].[EmailMessage] ([Id])
);

