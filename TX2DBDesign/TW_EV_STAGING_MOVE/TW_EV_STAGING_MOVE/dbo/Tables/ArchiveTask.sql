CREATE TABLE [dbo].[ArchiveTask] (
    [Id]                   BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProgramId]            INT            NULL,
    [TaskName]             NVARCHAR (100) NOT NULL,
    [TaskSP]               NVARCHAR (100) NOT NULL,
    [LastExecuteStartTime] DATETIME       NULL,
    [LastExecuteEndTime]   DATETIME       NULL,
    [LastExecuteLogId]     BIGINT         NULL,
    [LastExecuteStatus]    TINYINT        NULL,
    [LastExecuteDataCount] INT            DEFAULT ((0)) NULL,
    [ArchivedDataEndId]    BIGINT         NULL,
    [Sequence]             INT            NOT NULL,
    CONSTRAINT [PK_ArchiveTask_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

