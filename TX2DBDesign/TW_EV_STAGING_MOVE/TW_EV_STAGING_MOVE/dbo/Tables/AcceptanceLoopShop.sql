CREATE TABLE [dbo].[AcceptanceLoopShop] (
    [Id]                       INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AcceptanceLoopMerchantId] INT NOT NULL,
    [ShopId]                   INT NOT NULL,
    CONSTRAINT [PK_ACCEPTANCELOOPSHOP] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ACCEPTAN_REFERENCE_SHOP] FOREIGN KEY ([ShopId]) REFERENCES [dbo].[Shop] ([Id]),
    CONSTRAINT [FK_AcceptanceLoopShop_AcceptanceLoopMerchant_AcceptanceLoopMerchantId] FOREIGN KEY ([AcceptanceLoopMerchantId]) REFERENCES [dbo].[AcceptanceLoopMerchant] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [ID_AcceptanceLoopShop_AcceptanceLoopMerchantId_ShopId]
    ON [dbo].[AcceptanceLoopShop]([AcceptanceLoopMerchantId] DESC, [ShopId] DESC) WITH (FILLFACTOR = 90);

