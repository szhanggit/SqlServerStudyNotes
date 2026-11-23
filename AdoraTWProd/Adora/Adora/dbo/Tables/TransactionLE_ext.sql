CREATE TABLE [dbo].[TransactionLE_ext] (
    [Id]            BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AccountNumber] VARCHAR (50) NULL,
    [TranCode]      VARCHAR (50) NULL,
    [PreTranType]   INT          NULL,
    [InitBalance]   INT          NULL,
    [LEBalance]     INT          NULL,
    CONSTRAINT [PK_TransactionLE_ext] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_TransactionLE_ext_AccountNumber_TranCode]
    ON [dbo].[TransactionLE_ext]([AccountNumber] ASC, [TranCode] ASC) WITH (FILLFACTOR = 90);

