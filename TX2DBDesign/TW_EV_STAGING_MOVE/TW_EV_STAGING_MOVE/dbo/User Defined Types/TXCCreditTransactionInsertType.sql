CREATE TYPE [dbo].[TXCCreditTransactionInsertType] AS TABLE (
    [ClientId]      INT             NOT NULL,
    [VoucherId]     BIGINT          NULL,
    [OrderId]       INT             NULL,
    [OrderlineId]   INT             NULL,
    [TransactionId] BIGINT          NULL,
    [CreditAmount]  DECIMAL (18, 2) NOT NULL,
    [SessionId]     VARCHAR (50)    NULL);

