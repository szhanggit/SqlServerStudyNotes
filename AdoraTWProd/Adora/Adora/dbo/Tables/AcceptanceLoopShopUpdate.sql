CREATE TABLE [dbo].[AcceptanceLoopShopUpdate] (
    [ProductExternalId]  VARCHAR (50)   NULL,
    [ProductName]        NVARCHAR (200) NULL,
    [ProductId]          INT            NULL,
    [MerchantCode]       VARCHAR (50)   NULL,
    [MerchantName]       NVARCHAR (100) NULL,
    [MerchantExternalId] VARCHAR (50)   NULL,
    [MerchantId]         INT            NULL,
    [ShopCode]           VARCHAR (50)   NULL,
    [ShopName]           NVARCHAR (100) NULL,
    [ShopExternalId]     VARCHAR (50)   NULL,
    [ShopId]             INT            NULL,
    [AcceptanceLoopId]   INT            NULL
);

