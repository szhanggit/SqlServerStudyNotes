CREATE TABLE [dbo].[TransactionFeeArchive] (
    [Id]             BIGINT          NOT NULL,
    [TransactionId]  BIGINT          NOT NULL,
    [ServiceFeeId]   INT             NOT NULL,
    [TranFee]        NUMERIC (20, 6) NOT NULL,
    [TranFeeWithTax] NUMERIC (20, 6) NULL,
    [IsValid]        BIT             NULL
);

