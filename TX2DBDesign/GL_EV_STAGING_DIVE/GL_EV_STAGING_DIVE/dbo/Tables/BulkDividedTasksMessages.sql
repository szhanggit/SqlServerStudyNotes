CREATE TABLE [dbo].[BulkDividedTasksMessages] (
    [Id]                 BIGINT         IDENTITY (1, 1) NOT NULL,
    [BulkDividedTasksId] BIGINT         NOT NULL,
    [MessageId]          BIGINT         NOT NULL,
    [MessageType]        INT            NOT NULL,
    [MessageSPId]        NVARCHAR (100) NULL,
    [MessageStatus]      INT            NULL,
    [SentOnUTC]          DATETIME       NULL,
    CONSTRAINT [PK_BulkDividedTasksMessages_Id] PRIMARY KEY CLUSTERED ([Id] DESC),
    FOREIGN KEY ([BulkDividedTasksId]) REFERENCES [dbo].[BulkDividedTasks] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [Index_Self_BulkDividedTasksId_MessageId]
    ON [dbo].[BulkDividedTasksMessages]([BulkDividedTasksId] ASC, [MessageId] ASC);

