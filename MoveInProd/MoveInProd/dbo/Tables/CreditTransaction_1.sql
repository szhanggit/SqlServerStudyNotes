CREATE TABLE [dbo].[CreditTransaction] (
    [ClientId]     INT             NOT NULL,
    [VoucherId]    BIGINT          NOT NULL,
    [CreditAmount] DECIMAL (18, 2) NOT NULL,
    [SessionId]    VARCHAR (50)    NULL
);


GO
CREATE NONCLUSTERED INDEX [Index_CreditTransaction_VoucherId]
    ON [dbo].[CreditTransaction]([VoucherId] ASC);


GO
CREATE NONCLUSTERED INDEX [Index_CreditTransaction_SessionId]
    ON [dbo].[CreditTransaction]([SessionId] ASC);

