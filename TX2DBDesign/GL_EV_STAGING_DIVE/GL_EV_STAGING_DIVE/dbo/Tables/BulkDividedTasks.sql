CREATE TABLE [dbo].[BulkDividedTasks] (
    [Id]            BIGINT   IDENTITY (1, 1) NOT NULL,
    [TaskId]        BIGINT   NOT NULL,
    [TaskStatus]    INT      NOT NULL,
    [MessageNumber] INT      NOT NULL,
    [CreatedOn]     DATETIME NOT NULL,
    [ProcessedOn]   DATETIME NULL,
    [TriedCount]    INT      NULL,
    CONSTRAINT [PK_BulkDividedTasks_Id] PRIMARY KEY CLUSTERED ([Id] DESC),
    FOREIGN KEY ([TaskId]) REFERENCES [dbo].[Task] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [Index_Self_TaskId]
    ON [dbo].[BulkDividedTasks]([TaskId] ASC);

