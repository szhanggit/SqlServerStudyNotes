CREATE TABLE [dbo].[ReimbursementScheme] (
    [Id]                 INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MerchantContractId] INT             NOT NULL,
    [TransactionTypeId]  INT             NOT NULL,
    [Value]              NUMERIC (15, 4) DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_REIMBURSEMENTSCHEME] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ReimbursementScheme_Dictionary_TransactionTypeId] FOREIGN KEY ([TransactionTypeId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [FK_ReimbursementScheme_MerchantContract_MerchantContractId] FOREIGN KEY ([MerchantContractId]) REFERENCES [dbo].[MerchantContract] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IDX_ReimbursementScheme_TransactionTypeId]
    ON [dbo].[ReimbursementScheme]([TransactionTypeId] ASC)
    INCLUDE([MerchantContractId]);


GO
CREATE NONCLUSTERED INDEX [IDX_ReimbursementScheme_TransactionTypeId_2]
    ON [dbo].[ReimbursementScheme]([TransactionTypeId] ASC)
    INCLUDE([Id], [MerchantContractId], [Value]);

