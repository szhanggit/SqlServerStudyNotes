CREATE TABLE [dbo].[TransactionFee] (
    [Id]            BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TransactionId] BIGINT          NOT NULL,
    [ServiceFeeId]  INT             NOT NULL,
    [TranFee]       NUMERIC (20, 6) NOT NULL,
    CONSTRAINT [PK_TransactionFee_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TransactionFee_ServiceFee_ServiceFeeId] FOREIGN KEY ([ServiceFeeId]) REFERENCES [dbo].[ServiceFee] ([Id]),
    CONSTRAINT [FK_TransactionFee_Transaction_TransactionId] FOREIGN KEY ([TransactionId]) REFERENCES [dbo].[Transaction] ([Id])
);

