CREATE TABLE [dbo].[SyncTranMap] (
    [OlapTranId]    BIGINT       NOT NULL,
    [MoTranId]      BIGINT       NULL,
    [VoucherNumber] VARCHAR (50) NOT NULL,
    [TranCode]      VARCHAR (50) NOT NULL,
    [SessionId]     VARCHAR (40) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [index_SyncTranMap_SessionId]
    ON [dbo].[SyncTranMap]([SessionId] ASC);

