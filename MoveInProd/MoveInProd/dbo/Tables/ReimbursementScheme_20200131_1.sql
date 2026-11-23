CREATE TABLE [dbo].[ReimbursementScheme_20200131] (
    [Id]                 INT             IDENTITY (1, 1) NOT NULL,
    [MerchantContractId] INT             NOT NULL,
    [TransactionTypeId]  INT             NOT NULL,
    [Value]              NUMERIC (15, 4) NOT NULL
);

