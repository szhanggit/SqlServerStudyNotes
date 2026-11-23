CREATE TABLE [dbo].[ConcurrencyLog] (
    [Id]          BIGINT       IDENTITY (1, 1) NOT NULL,
    [RequestId]   VARCHAR (50) NOT NULL,
    [UpdatedTime] BIGINT       NOT NULL,
    CONSTRAINT [PK_ConcurrencyLog_Id] PRIMARY KEY CLUSTERED ([Id] DESC),
    UNIQUE NONCLUSTERED ([RequestId] ASC)
);

