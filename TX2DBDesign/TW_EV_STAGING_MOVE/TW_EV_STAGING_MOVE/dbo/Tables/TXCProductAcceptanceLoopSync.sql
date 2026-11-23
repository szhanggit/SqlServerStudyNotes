CREATE TABLE [dbo].[TXCProductAcceptanceLoopSync] (
    [RunId]                      VARCHAR (50) NOT NULL,
    [TXCProductAcceptanceLoopId] INT          NULL,
    [TXCMerchantId]              INT          NULL,
    [TXCShopId]                  INT          NULL,
    [TX2MerchantId]              INT          NULL,
    [TX2ShopId]                  INT          NULL
);


GO
CREATE CLUSTERED INDEX [IX_TXCProductAcceptanceLoopSync]
    ON [dbo].[TXCProductAcceptanceLoopSync]([RunId] ASC, [TXCProductAcceptanceLoopId] ASC) WITH (FILLFACTOR = 90);

