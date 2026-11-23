CREATE TABLE [dbo].[SGAccountTypeProductMapping] (
    [Id]            INT          IDENTITY (1, 1) NOT NULL,
    [AccountType]   VARCHAR (20) NOT NULL,
    [ProductId]     INT          NOT NULL,
    [IsMainAccount] BIT          NOT NULL,
    CONSTRAINT [PK_SGAccountTypeProductMapping_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_SGAccountTypeProductMapping_Product_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id])
);

