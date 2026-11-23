CREATE TABLE [dbo].[AccountBatchActivateRecords] (
    [Id]             BIGINT IDENTITY (1, 1) NOT NULL,
    [SequenceNumber] BIGINT NOT NULL,
    [CreatedUTCTime] BIGINT NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [index_AccountBatchActivateRecords_SequenceNumber]
    ON [dbo].[AccountBatchActivateRecords]([SequenceNumber] ASC);

