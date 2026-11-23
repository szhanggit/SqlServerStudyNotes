CREATE TABLE [dbo].[ArchiveTaskLog] (
    [Id]                           BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TaskId]                       BIGINT         NOT NULL,
    [ExecuteStartTime]             DATETIME       NOT NULL,
    [ExecuteEndTime]               DATETIME       NULL,
    [Status]                       TINYINT        NOT NULL,
    [DataCount]                    INT            DEFAULT ((0)) NULL,
    [LastExecuteArchivedDataEndId] BIGINT         NULL,
    [ArchivedDataStartId]          BIGINT         NULL,
    [ArchivedDataEndId]            BIGINT         NULL,
    [Comment]                      NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_ArchiveTaskLog_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ArchiveTaskLog_ArchiveTask_ArchiveTaskId] FOREIGN KEY ([TaskId]) REFERENCES [dbo].[ArchiveTask] ([Id])
);

