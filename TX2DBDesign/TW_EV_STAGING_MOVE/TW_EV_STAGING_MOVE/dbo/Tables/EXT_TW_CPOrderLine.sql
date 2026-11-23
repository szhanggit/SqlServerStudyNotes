CREATE TABLE [dbo].[EXT_TW_CPOrderLine] (
    [Id]                INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OrderLineId]       INT NOT NULL,
    [CPPurchaseOrderId] INT NOT NULL,
    CONSTRAINT [PK_EXT_TW_CPOrderLine_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EXT_TW_CPOrderLine_CPPurchaseOrder_CPPurchaseOrderId] FOREIGN KEY ([CPPurchaseOrderId]) REFERENCES [dbo].[EXT_TW_CPPurchaseOrder] ([Id]),
    CONSTRAINT [FK_EXT_TW_CPOrderLine_OrderLine_OrderLineId] FOREIGN KEY ([OrderLineId]) REFERENCES [dbo].[OrderLine] ([Id])
);

