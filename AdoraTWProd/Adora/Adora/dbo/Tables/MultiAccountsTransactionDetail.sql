CREATE TABLE [dbo].[MultiAccountsTransactionDetail] (
    [Id]                         BIGINT       IDENTITY (1, 1) NOT NULL,
    [MultiAccountsTransactionId] BIGINT       NOT NULL,
    [AccountNumber]              VARCHAR (50) NOT NULL,
    [TranAmount]                 INT          DEFAULT ((0)) NOT NULL,
    [TranCode]                   VARCHAR (50) NULL,
    [TranCodeRef]                VARCHAR (50) NULL,
    CONSTRAINT [PK_MultiAccountsTransactionDetail_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_MultiAccountsTransactionDetail_MultiAccountsTransaction_MultiAccountsTransactionId] FOREIGN KEY ([MultiAccountsTransactionId]) REFERENCES [dbo].[MultiAccountsTransaction] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IDX_MultiAccountsTransactionDetail_AccountNumber]
    ON [dbo].[MultiAccountsTransactionDetail]([MultiAccountsTransactionId] ASC, [AccountNumber] ASC) WITH (FILLFACTOR = 90);

