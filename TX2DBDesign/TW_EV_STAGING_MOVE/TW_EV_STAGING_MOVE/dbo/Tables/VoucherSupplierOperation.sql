CREATE TABLE [dbo].[VoucherSupplierOperation] (
    [Id]                INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VoucherSupplierId] INT          NOT NULL,
    [OperationCode]     VARCHAR (50) NOT NULL,
    [OperationName]     VARCHAR (50) NOT NULL,
    [ThrottleRate]      INT          NULL,
    CONSTRAINT [PK_VoucherSupplierOperation_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_VoucherSupplierOperation_VoucherSupplier_VoucherSupplierId] FOREIGN KEY ([VoucherSupplierId]) REFERENCES [dbo].[VoucherSupplier] ([Id])
);

