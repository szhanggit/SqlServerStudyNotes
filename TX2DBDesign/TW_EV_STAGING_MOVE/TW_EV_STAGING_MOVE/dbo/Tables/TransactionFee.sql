CREATE TABLE [dbo].[TransactionFee] (
    [Id]             BIGINT          IDENTITY (1, 1) NOT NULL,
    [TransactionId]  BIGINT          NOT NULL,
    [ServiceFeeId]   INT             NOT NULL,
    [TranFee]        NUMERIC (20, 6) NOT NULL,
    [TranFeeWithTax] NUMERIC (20, 6) NULL,
    [IsValid]        BIT             NULL,
    CONSTRAINT [PK_TransactionFee_Id_1029] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

