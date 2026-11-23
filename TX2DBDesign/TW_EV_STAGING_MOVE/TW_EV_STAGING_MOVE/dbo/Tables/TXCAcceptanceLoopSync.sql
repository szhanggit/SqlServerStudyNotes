CREATE TABLE [dbo].[TXCAcceptanceLoopSync] (
    [RunId]         VARCHAR (50) NOT NULL,
    [TXCProductId]  INT          NOT NULL,
    [TXCMerchantId] INT          NOT NULL,
    [TXCShopId]     INT          NULL,
    [TX2ProductId]  INT          NULL,
    [TX2MerchantId] INT          NULL,
    [TX2ShopId]     INT          NULL
);


GO
CREATE CLUSTERED INDEX [IX_TXCAcceptanceLoopSync]
    ON [dbo].[TXCAcceptanceLoopSync]([RunId] ASC) WITH (FILLFACTOR = 90);

