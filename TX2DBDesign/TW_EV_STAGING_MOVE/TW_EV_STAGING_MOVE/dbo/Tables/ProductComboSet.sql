CREATE TABLE [dbo].[ProductComboSet] (
    [Id]                    INT IDENTITY (1, 1) NOT NULL,
    [ProductComboId]        INT NOT NULL,
    [ChildProductId]        INT NOT NULL,
    [ChildProductVersionId] INT NOT NULL,
    [Sequence]              INT NULL,
    [Status]                INT CONSTRAINT [DF_PCS_Status] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ProductComboSet_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductComboSet_Product_ChildProductId] FOREIGN KEY ([ChildProductId]) REFERENCES [dbo].[Product] ([Id]),
    CONSTRAINT [FK_ProductComboSet_ProductCombo_ProductComboId] FOREIGN KEY ([ProductComboId]) REFERENCES [dbo].[ProductCombo] ([Id]),
    CONSTRAINT [FK_ProductComboSet_ProductVersion_ChildProductVersionId] FOREIGN KEY ([ChildProductVersionId]) REFERENCES [dbo].[ProductVersion] ([Id])
);

