CREATE TABLE [dbo].[BatchClearStatistics] (
    [BatchId]       BIGINT       NOT NULL,
    [TranLocalDate] VARCHAR (8)  NOT NULL,
    [ProgramCode]   VARCHAR (20) NOT NULL,
    [ProductId]     INT          NOT NULL,
    [MerchantId]    INT          NOT NULL,
    [TranType]      SMALLINT     NOT NULL,
    [TranCount]     INT          NOT NULL,
    [TranAmount]    BIGINT       NOT NULL,
    CONSTRAINT [FK_BatchClearStatistics_Batch_BatchId] FOREIGN KEY ([BatchId]) REFERENCES [dbo].[Batch] ([Id]),
    CONSTRAINT [FK_BatchClearStatistics_Merchant_MerchantId] FOREIGN KEY ([MerchantId]) REFERENCES [dbo].[Merchant] ([Id]),
    CONSTRAINT [FK_BatchClearStatistics_Product_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id])
);

