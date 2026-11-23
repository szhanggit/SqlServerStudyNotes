CREATE TABLE [dbo].[BusinessModel] (
    [Id]                 INT     IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [IsPrepaid]          BIT     NOT NULL,
    [DisplayNameId]      INT     NOT NULL,
    [FinanceFormulaType] TINYINT NOT NULL,
    CONSTRAINT [PK_BUSINESSMODEL] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_BusinessModel_Dictionary_DisplayNameId] FOREIGN KEY ([DisplayNameId]) REFERENCES [dbo].[Dictionary] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1--Prepaid
   2--Postpaid
   3--Cost', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'BusinessModel', @level2type = N'COLUMN', @level2name = N'FinanceFormulaType';

