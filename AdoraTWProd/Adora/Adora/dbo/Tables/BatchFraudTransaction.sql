CREATE TABLE [dbo].[BatchFraudTransaction] (
    [BatchId]       BIGINT       NOT NULL,
    [ProgramCode]   VARCHAR (20) NOT NULL,
    [IdentityCode]  VARCHAR (20) NOT NULL,
    [IdentityType]  TINYINT      NOT NULL,
    [AccountNumber] VARCHAR (50) NOT NULL,
    [TranCode]      VARCHAR (50) NOT NULL,
    [TranType]      SMALLINT     NOT NULL,
    [ResponseCode]  VARCHAR (5)  NULL,
    CONSTRAINT [FK_BatchFraudTransaction_Batch_BatchId] FOREIGN KEY ([BatchId]) REFERENCES [dbo].[Batch] ([Id])
);

