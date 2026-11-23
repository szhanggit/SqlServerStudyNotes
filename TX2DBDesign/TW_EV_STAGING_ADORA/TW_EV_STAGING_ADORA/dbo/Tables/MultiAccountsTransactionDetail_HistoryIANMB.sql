CREATE TABLE [dbo].[MultiAccountsTransactionDetail_HistoryIANMB] (
    [Id]                         BIGINT       NOT NULL,
    [MultiAccountsTransactionId] BIGINT       NOT NULL,
    [AccountNumber]              VARCHAR (50) NOT NULL,
    [TranAmount]                 INT          NOT NULL,
    [TranCode]                   VARCHAR (50) NULL,
    [TranCodeRef]                VARCHAR (50) NULL
);

