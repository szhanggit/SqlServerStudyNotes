CREATE TABLE [dbo].[AccountBatchReverseActivateRecords] (
    [Id]             BIGINT IDENTITY (1, 1) NOT NULL,
    [SequenceNumber] BIGINT NOT NULL,
    [CreatedUTCTime] BIGINT NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [index_AccountBatchReverseActivateRecords_SequenceNumber]
    ON [dbo].[AccountBatchReverseActivateRecords]([SequenceNumber] ASC);

