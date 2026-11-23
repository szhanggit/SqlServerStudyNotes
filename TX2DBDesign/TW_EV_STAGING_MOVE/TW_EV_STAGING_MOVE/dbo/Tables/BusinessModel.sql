CREATE TABLE [dbo].[BusinessModel] (
    [Id]                 INT     IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [IsPrepaid]          BIT     NOT NULL,
    [DisplayNameId]      INT     NOT NULL,
    [FinanceFormulaType] TINYINT NOT NULL,
    CONSTRAINT [PK_BUSINESSMODEL] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_BusinessModel_Dictionary_DisplayNameId] FOREIGN KEY ([DisplayNameId]) REFERENCES [dbo].[Dictionary] ([Id])
);

