CREATE TABLE [dbo].[VoucherStockTimer] (
    [OrderLineId]    BIGINT   NOT NULL,
    [CacheNodeId]    TINYINT  NOT NULL,
    [EndTime]        DATETIME NOT NULL,
    [LastUpdateDate] DATETIME NOT NULL,
    CONSTRAINT [PK_VoucherStockTimer] PRIMARY KEY CLUSTERED ([OrderLineId] ASC, [CacheNodeId] ASC)
);

