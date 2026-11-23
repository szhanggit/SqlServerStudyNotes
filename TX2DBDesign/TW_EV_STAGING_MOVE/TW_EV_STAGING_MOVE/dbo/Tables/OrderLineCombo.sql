CREATE TABLE [dbo].[OrderLineCombo] (
    [Id]                INT      IDENTITY (1, 1) NOT NULL,
    [OrderLineId]       INT      NOT NULL,
    [ProductComboSetId] INT      NOT NULL,
    [ExchangeTime]      DATETIME NULL,
    CONSTRAINT [PK_OrderLineCombo_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_OrderLineCombo_OrderLine_OrderLineId] FOREIGN KEY ([OrderLineId]) REFERENCES [dbo].[OrderLine] ([Id]),
    CONSTRAINT [FK_OrderLineCombo_ProductComboSet_ProductComboSetId] FOREIGN KEY ([ProductComboSetId]) REFERENCES [dbo].[ProductComboSet] ([Id])
);

