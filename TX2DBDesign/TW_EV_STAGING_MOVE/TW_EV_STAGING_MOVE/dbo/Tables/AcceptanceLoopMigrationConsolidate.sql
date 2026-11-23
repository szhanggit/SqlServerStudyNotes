CREATE TABLE [dbo].[AcceptanceLoopMigrationConsolidate] (
    [AcceptanceLoopId] INT           NOT NULL,
    [MerchantShop]     VARCHAR (MAX) NOT NULL,
    [MerchantCount]    INT           NOT NULL,
    [ShopCount]        INT           NOT NULL,
    [IsDefault]        BIT           NULL,
    [ExternalId]       INT           NULL
);

