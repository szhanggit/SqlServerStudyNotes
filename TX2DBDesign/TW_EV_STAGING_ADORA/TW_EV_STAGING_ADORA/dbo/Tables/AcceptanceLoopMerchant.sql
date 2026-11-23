CREATE TABLE [dbo].[AcceptanceLoopMerchant] (
    [Id]               INT IDENTITY (1, 1) NOT NULL,
    [AcceptanceLoopId] INT NULL,
    [MerchantId]       INT NULL,
    CONSTRAINT [PK_AcceptanceLoopMerchant_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ALMerchant_ALAcceptanceLoop_ALId] FOREIGN KEY ([AcceptanceLoopId]) REFERENCES [dbo].[AcceptanceLoop] ([Id]),
    CONSTRAINT [FK_ALMerchant_Merchant_MerchantId] FOREIGN KEY ([MerchantId]) REFERENCES [dbo].[Merchant] ([Id]),
    CONSTRAINT [UK_AcceptanceLoopMerchant_AcceptanceLoopId_MerchantId] UNIQUE CLUSTERED ([AcceptanceLoopId] ASC, [MerchantId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_AcceptanceLoopMerchant_AcceptanceLoopId]
    ON [dbo].[AcceptanceLoopMerchant]([AcceptanceLoopId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_AcceptanceLoopMerchant_MerchantId]
    ON [dbo].[AcceptanceLoopMerchant]([MerchantId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_AcceptanceLoopMerchant_Id_2]
    ON [dbo].[AcceptanceLoopMerchant]([Id] ASC)
    INCLUDE([AcceptanceLoopId], [MerchantId]);

