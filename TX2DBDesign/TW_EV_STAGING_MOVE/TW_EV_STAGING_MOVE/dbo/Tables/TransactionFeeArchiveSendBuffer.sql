CREATE TABLE [dbo].[TransactionFeeArchiveSendBuffer] (
    [Id]            BIGINT          NOT NULL,
    [TransactionId] BIGINT          NOT NULL,
    [ServiceFeeId]  INT             NOT NULL,
    [TranFee]       NUMERIC (20, 6) NOT NULL,
    CONSTRAINT [PK_TransactionFeeArchiveSendBuffer_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);

