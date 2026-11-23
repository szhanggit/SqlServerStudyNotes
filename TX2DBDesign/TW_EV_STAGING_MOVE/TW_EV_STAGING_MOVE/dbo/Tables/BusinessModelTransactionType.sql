CREATE TABLE [dbo].[BusinessModelTransactionType] (
    [Id]                      INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BusinessModelId]         INT      NOT NULL,
    [TransactionTypeId]       INT      NOT NULL,
    [IsFaceValueBasedInvoice] BIT      NOT NULL,
    [FaceValueCoefficient]    SMALLINT DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_BUSINESSMODELTRANSACTIONTYP] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_BusinessModuleTransactionType_BusinessModule_BusinessModuleId] FOREIGN KEY ([BusinessModelId]) REFERENCES [dbo].[BusinessModel] ([Id]),
    CONSTRAINT [FK_BusinessModuleTransactionType_Dictionary_TransactionTypeId] FOREIGN KEY ([TransactionTypeId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [UK_BusinessModuleTransactionType_BusinessModuleId_TransactionTypeId] UNIQUE NONCLUSTERED ([BusinessModelId] ASC, [TransactionTypeId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'The value could be 1,-1,0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'BusinessModelTransactionType', @level2type = N'COLUMN', @level2name = N'FaceValueCoefficient';

