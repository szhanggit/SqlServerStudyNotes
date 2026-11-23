CREATE TABLE [dbo].[TXCShopMapping] (
    [Id]        BIGINT IDENTITY (1, 1) NOT NULL,
    [TX2ShopId] INT    NOT NULL,
    [TXCShopId] INT    NULL,
    [TenantId]  INT    NOT NULL,
    CONSTRAINT [PK_TXCShopMapping_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

