CREATE TABLE [dbo].[BulkDividedTaskActionLog] (
    [Id]                 BIGINT         IDENTITY (1, 1) NOT NULL,
    [BulkDividedTasksId] BIGINT         NOT NULL,
    [BulkTaskActionType] INT            NOT NULL,
    [CreatedOn]          DATETIME       NOT NULL,
    [MISCInfo]           NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_BulkDividedTaskActionLog_Id] PRIMARY KEY CLUSTERED ([Id] DESC),
    FOREIGN KEY ([BulkDividedTasksId]) REFERENCES [dbo].[BulkDividedTasks] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [Index_Self_BulkDividedTaskActionLog_BulkDividedTasksId]
    ON [dbo].[BulkDividedTaskActionLog]([BulkDividedTasksId] ASC);

