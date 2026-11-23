CREATE TABLE [dbo].[ProductVoucherSupplierOperationParameter] (
    [Id]                                  INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProductId]                           INT            NOT NULL,
    [VoucherSupplierOperationParameterId] INT            NOT NULL,
    [ParameterValue]                      NVARCHAR (200) NOT NULL,
    CONSTRAINT [PK_ProductVoucherSupplierOperationParameter_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductVoucherSupplierOperationParameter_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id]),
    CONSTRAINT [FK_ProductVoucherSupplierOperationParameter_VoucherSupplierOperationParameterId] FOREIGN KEY ([VoucherSupplierOperationParameterId]) REFERENCES [dbo].[VoucherSupplierOperationParameter] ([Id])
);

