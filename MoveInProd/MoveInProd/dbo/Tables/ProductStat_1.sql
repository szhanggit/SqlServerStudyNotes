CREATE TABLE [dbo].[ProductStat] (
    [Id]                      INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProductId]               INT           NOT NULL,
    [VoucherNumberFullLength] TINYINT       NULL,
    [MiniVoucherNumber]       NVARCHAR (50) NULL,
    [MaxVoucherNumber]        NVARCHAR (50) NULL,
    [MaxQuantity]             BIGINT        NULL,
    [GeneratedQuantity]       BIGINT        NOT NULL,
    [InStockQuantity]         BIGINT        NOT NULL,
    [HighWatermark]           INT           NOT NULL,
    [LowWatermark]            INT           NOT NULL,
    [LastModifiedOn]          DATETIME      NOT NULL,
    [InCacheQuantity]         BIGINT        DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ProductStat] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ProductStat_Product_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id]),
    CONSTRAINT [UK_ProductStat_ProductId] UNIQUE NONCLUSTERED ([ProductId] ASC) WITH (FILLFACTOR = 90)
);

