CREATE TABLE [dbo].[AcceptanceLoopShop] (
    [Id]               INT IDENTITY (1, 1) NOT NULL,
    [AcceptanceLoopId] INT NOT NULL,
    [ShopId]           INT NOT NULL,
    CONSTRAINT [PK_AcceptanceLoopShop_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ALShop_ALAcceptanceLoop_ALId] FOREIGN KEY ([AcceptanceLoopId]) REFERENCES [dbo].[AcceptanceLoop] ([Id]),
    CONSTRAINT [FK_ALShop_Shop_ShopId] FOREIGN KEY ([ShopId]) REFERENCES [dbo].[Shop] ([Id]),
    CONSTRAINT [UK_AcceptanceLoopShop_AcceptanceLoopId_ShopId] UNIQUE CLUSTERED ([AcceptanceLoopId] ASC, [ShopId] ASC)
);

