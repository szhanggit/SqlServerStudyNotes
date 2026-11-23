CREATE TABLE [dbo].[EmailMessageArchiveTemp] (
    [SessionId]      VARCHAR (50) NOT NULL,
    [EmailMessageId] BIGINT       NOT NULL,
    [TaskId]         BIGINT       NOT NULL,
    CONSTRAINT [PK_EmailMessageArchiveTemp] PRIMARY KEY CLUSTERED ([SessionId] ASC, [EmailMessageId] ASC)
);

