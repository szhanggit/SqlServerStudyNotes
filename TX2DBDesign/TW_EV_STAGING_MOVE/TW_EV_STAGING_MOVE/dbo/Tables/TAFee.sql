CREATE TABLE [dbo].[TAFee] (
    [Id]            BIGINT          IDENTITY (1, 1) NOT NULL,
    [TransactionId] BIGINT          NOT NULL,
    [ServiceFeeId]  INT             NOT NULL,
    [TranFee]       NUMERIC (20, 6) NOT NULL
);

