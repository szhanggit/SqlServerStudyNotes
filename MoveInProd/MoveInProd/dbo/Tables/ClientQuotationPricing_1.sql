CREATE TABLE [dbo].[ClientQuotationPricing] (
    [Id]                       INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientQuotationProductId] INT             NOT NULL,
    [TransactionTypeId]        INT             NOT NULL,
    [InvoiceClient]            NUMERIC (15, 4) NOT NULL,
    [ValueBasedInvoiceClient]  NUMERIC (15, 4) NULL,
    [ValidityFrom]             DATETIME        NOT NULL,
    [ValidityEnd]              DATETIME        NOT NULL,
    CONSTRAINT [PK_CLIENTQUOTATIONPRICING] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ClientQuotationPricing_ClientQuotationProduct_ClientQuotationProductId] FOREIGN KEY ([ClientQuotationProductId]) REFERENCES [dbo].[ClientQuotationProduct] ([Id]),
    CONSTRAINT [FK_ClientQuotationPricing_Dictionary_TransactionTypeId] FOREIGN KEY ([TransactionTypeId]) REFERENCES [dbo].[Dictionary] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IDX_ClientQuotationPricing_Validity]
    ON [dbo].[ClientQuotationPricing]([ValidityFrom] ASC, [ValidityEnd] ASC, [Id] ASC)
    INCLUDE([ClientQuotationProductId], [TransactionTypeId]) WITH (FILLFACTOR = 90);

