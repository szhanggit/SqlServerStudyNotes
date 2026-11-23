CREATE TABLE [dbo].[ReverseCreditTransaction] (
    [ClientId]      INT             NOT NULL,
    [VoucherId]     BIGINT          NOT NULL,
    [CreditAmount]  DECIMAL (18, 2) NOT NULL,
    [SessionId]     VARCHAR (50)    NULL,
    [TransactionId] BIGINT          NULL
);


GO
CREATE NONCLUSTERED INDEX [Index_ReverseCreditTransaction_VoucherId]
    ON [dbo].[ReverseCreditTransaction]([VoucherId] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [Index_ReverseCreditTransaction_SessionId]
    ON [dbo].[ReverseCreditTransaction]([SessionId] ASC) WITH (FILLFACTOR = 90);

