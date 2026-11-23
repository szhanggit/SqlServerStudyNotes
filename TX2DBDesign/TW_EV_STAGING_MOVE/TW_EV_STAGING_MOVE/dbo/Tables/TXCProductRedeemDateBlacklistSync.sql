CREATE TABLE [dbo].[TXCProductRedeemDateBlacklistSync] (
    [RunId]                           VARCHAR (50) NOT NULL,
    [TXCProductRedeemDateBlacklistId] INT          NULL,
    [TXCBlackDate]                    DATETIME     NULL,
    [BlackDate]                       DATE         NULL
);


GO
CREATE CLUSTERED INDEX [IX_TXCProductRedeemDateBlacklistSync]
    ON [dbo].[TXCProductRedeemDateBlacklistSync]([RunId] ASC, [TXCProductRedeemDateBlacklistId] ASC) WITH (FILLFACTOR = 90);

