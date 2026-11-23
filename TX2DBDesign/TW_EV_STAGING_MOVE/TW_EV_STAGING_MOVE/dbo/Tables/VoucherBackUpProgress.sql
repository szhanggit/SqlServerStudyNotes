CREATE TABLE [dbo].[VoucherBackUpProgress] (
    [Id]                   INT    IDENTITY (1, 1) NOT NULL,
    [ExtendVoucherId]      BIGINT NULL,
    [GenerateUrlVoucherId] BIGINT NULL,
    [UpdateUrlVoucherId]   BIGINT NULL,
    [MoveToStockVoucherId] BIGINT NULL,
    [VoucherTriggerId]     BIGINT NULL,
    [StockTriggerId]       BIGINT NULL,
    CONSTRAINT [PK_VoucherBackUpProgress_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

