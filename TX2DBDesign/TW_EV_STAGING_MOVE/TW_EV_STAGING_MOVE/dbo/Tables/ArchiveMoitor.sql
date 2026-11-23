CREATE TABLE [dbo].[ArchiveMoitor] (
    [Id]               BIGINT   IDENTITY (1, 1) NOT NULL,
    [ArchiveTaskLogId] BIGINT   NOT NULL,
    [ArchiveStep]      TINYINT  NOT NULL,
    [StepTime]         DATETIME NOT NULL,
    CONSTRAINT [PK_ArchiveMoitor] PRIMARY KEY CLUSTERED ([Id] ASC)
);

