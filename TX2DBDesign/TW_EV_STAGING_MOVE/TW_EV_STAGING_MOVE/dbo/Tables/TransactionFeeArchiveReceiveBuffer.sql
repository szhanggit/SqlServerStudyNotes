CREATE TABLE [dbo].[TransactionFeeArchiveReceiveBuffer] (
    [Id]            BIGINT          NOT NULL,
    [TransactionId] BIGINT          NOT NULL,
    [ServiceFeeId]  INT             NOT NULL,
    [TranFee]       NUMERIC (20, 6) NOT NULL
);

