CREATE TABLE [dbo].[AcceptanceLoopMigrationDefault] (
    [Id]           INT           NOT NULL,
    [MerchantCode] VARCHAR (50)  NOT NULL,
    [MerchantShop] VARCHAR (MAX) NULL,
    [ExternalId]   INT           NULL
);

