CREATE TABLE [dbo].[TXCReverseCreditTransaction] (
    [Id]            BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientId]      INT             NOT NULL,
    [VoucherId]     BIGINT          NULL,
    [OrderId]       INT             NULL,
    [OrderlineId]   INT             NULL,
    [TransactionId] BIGINT          NULL,
    [CreditAmount]  DECIMAL (18, 2) NOT NULL,
    [SessionId]     VARCHAR (50)    NULL,
    CONSTRAINT [PK_TXCReverseCreditTransaction_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90, PAD_INDEX = ON)
);

