CREATE TABLE [dbo].[ClientQuotationProductSoldPriceHistory] (
    [Id]                       INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientQuotationProductId] INT             NOT NULL,
    [OldSoldPrice]             NUMERIC (15, 4) NOT NULL,
    [NewSoldPrice]             NUMERIC (15, 4) NOT NULL,
    [ApprovedBy]               NVARCHAR (50)   NULL,
    [ApprovedOn]               DATETIME        NULL,
    [SoldPriceWithTax]         NUMERIC (15, 4) NULL,
    [NewSoldPriceWithTax]      NUMERIC (15, 4) NULL,
    CONSTRAINT [PK_ClientQuotationProductSoldPriceHistory_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ClientQuotationProductSoldPriceHistory_ClientQuotationProduct_ClientQuotationProductId] FOREIGN KEY ([ClientQuotationProductId]) REFERENCES [dbo].[ClientQuotationProduct] ([Id])
);

