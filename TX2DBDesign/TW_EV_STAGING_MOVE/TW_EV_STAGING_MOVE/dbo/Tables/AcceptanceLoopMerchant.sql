CREATE TABLE [dbo].[AcceptanceLoopMerchant] (
    [Id]               INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AcceptanceLoopId] INT NOT NULL,
    [MerchantId]       INT NOT NULL,
    CONSTRAINT [PK_ACCEPTANCELOOPMERCHANT] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ACCEPTAN_REFERENCE_MERCHANT] FOREIGN KEY ([MerchantId]) REFERENCES [dbo].[Merchant] ([Id]),
    CONSTRAINT [FK_AcceptanceLoopMerchant_AcceptanceLoop_AcceptanceLoopId] FOREIGN KEY ([AcceptanceLoopId]) REFERENCES [dbo].[AcceptanceLoop] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_AcceptanceLoopMerchant_AcceptanceLoopId]
    ON [dbo].[AcceptanceLoopMerchant]([AcceptanceLoopId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_AcceptanceLoopMerchant_Id]
    ON [dbo].[AcceptanceLoopMerchant]([Id] ASC);

