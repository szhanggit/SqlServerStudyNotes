CREATE TABLE [dbo].[ResellerPricing] (
    [Id]                       INT             IDENTITY (1, 1) NOT NULL,
    [ClientQuotationProductId] INT             NOT NULL,
    [ResellerSoldPrice]        DECIMAL (15, 4) NOT NULL,
    [MerchantAcquirerFee]      DECIMAL (15, 4) NOT NULL,
    [VoucherIssuerFee]         DECIMAL (15, 4) NOT NULL,
    [Status]                   INT             NOT NULL,
    CONSTRAINT [PK_ResellerPricing_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_CQPID] FOREIGN KEY ([ClientQuotationProductId]) REFERENCES [dbo].[ClientQuotationProduct] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [index_CQPID]
    ON [dbo].[ResellerPricing]([ClientQuotationProductId] ASC);

