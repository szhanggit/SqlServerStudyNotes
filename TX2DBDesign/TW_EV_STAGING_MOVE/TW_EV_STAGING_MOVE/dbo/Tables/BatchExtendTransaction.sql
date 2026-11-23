CREATE TABLE [dbo].[BatchExtendTransaction] (
    [Id]                 BIGINT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BatchExtendId]      INT    NOT NULL,
    [BatchTransactionId] BIGINT NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [ID_BatchExtendTransaction_BatchExtendId]
    ON [dbo].[BatchExtendTransaction]([BatchExtendId] DESC) WITH (FILLFACTOR = 90);

