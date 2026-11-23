CREATE TABLE [dbo].[TransactionFeeBuffer] (
    [TransactionBufferId] BIGINT          NOT NULL,
    [ServiceFeeId]        INT             NOT NULL,
    [TranFee]             NUMERIC (20, 6) NOT NULL,
    [TranFeeWithTax]      NUMERIC (20, 6) NULL,
    [IsValid]             BIT             NULL,
    CONSTRAINT [FK_TransactionFeeBuffer_TransactionBuffer_TransactionBufferId] FOREIGN KEY ([TransactionBufferId]) REFERENCES [dbo].[TransactionBuffer] ([Id])
);

