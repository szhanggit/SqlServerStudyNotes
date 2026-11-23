CREATE TABLE [dbo].[ReimbursementLine] (
    [Id]                       BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SettleDate]               INT             NOT NULL,
    [ProductId]                INT             NOT NULL,
    [ReimbursementSchemeId]    INT             NOT NULL,
    [TransactionCount]         INT             NOT NULL,
    [Cost]                     NUMERIC (20, 6) NULL,
    [ReimbursementAmount]      NUMERIC (20, 6) DEFAULT ((0)) NOT NULL,
    [ReimbursementId]          BIGINT          NULL,
    [Status]                   TINYINT         NOT NULL,
    [CreatedOn]                DATETIME        NOT NULL,
    [ClientQuotationProductId] INT             NULL,
    CONSTRAINT [PK_ReimbursementLine_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ReimbursementLine_ClientQuotationProduct_ClientQuotationProductId] FOREIGN KEY ([ClientQuotationProductId]) REFERENCES [dbo].[ClientQuotationProduct] ([Id]),
    CONSTRAINT [FK_ReimbursementLine_Product_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id]),
    CONSTRAINT [FK_ReimbursementLine_Reimbursement_ReimbursementId] FOREIGN KEY ([ReimbursementId]) REFERENCES [dbo].[Reimbursement] ([Id]),
    CONSTRAINT [FK_ReimbursementLine_ReimbursementScheme_ReimbursementSchemeId] FOREIGN KEY ([ReimbursementSchemeId]) REFERENCES [dbo].[ReimbursementScheme] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--Created
   2--Cancelled', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ReimbursementLine', @level2type = N'COLUMN', @level2name = N'Status';

