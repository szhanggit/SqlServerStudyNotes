CREATE TABLE [dbo].[MultiAccountsTransactionDetail_History] (
    [Id]                         BIGINT       NOT NULL,
    [MultiAccountsTransactionId] BIGINT       NOT NULL,
    [AccountNumber]              VARCHAR (50) NOT NULL,
    [TranAmount]                 INT          CONSTRAINT [DF__MultiAcco__TranA__6D181FEC] DEFAULT ((0)) NOT NULL,
    [TranCode]                   VARCHAR (50) NULL,
    [TranCodeRef]                VARCHAR (50) NULL
);

