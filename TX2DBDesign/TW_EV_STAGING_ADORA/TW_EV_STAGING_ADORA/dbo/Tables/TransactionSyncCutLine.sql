CREATE TABLE [dbo].[TransactionSyncCutLine] (
    [Id]               BIGINT       IDENTITY (1, 1) NOT NULL,
    [SyncDestination]  VARCHAR (50) NOT NULL,
    [ProgramCode]      VARCHAR (20) NOT NULL,
    [TranUtcDateTimeL] BIGINT       NOT NULL,
    [CreatedOn]        DATETIME     NOT NULL,
    CONSTRAINT [PK_TransactionSyncCutLine_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

