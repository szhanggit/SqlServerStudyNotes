CREATE TABLE [dbo].[AcceptanceLoopMigration] (
    [AcceptanceLoopId]      INT           NOT NULL,
    [Merchant]              VARCHAR (MAX) NULL,
    [MerchantShop]          VARCHAR (MAX) NULL,
    [MerchantCount]         INT           NOT NULL,
    [ShopCount]             INT           NOT NULL,
    [ConsolidateId]         INT           NULL,
    [IsDefault]             BIT           NULL,
    [GroupAcceptanceLoopId] INT           NULL
);

