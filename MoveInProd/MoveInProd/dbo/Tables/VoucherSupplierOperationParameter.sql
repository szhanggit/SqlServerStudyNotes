CREATE TABLE [dbo].[VoucherSupplierOperationParameter] (
    [Id]                         INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VoucherSupplierOperationId] INT            NOT NULL,
    [Name]                       VARCHAR (50)   NOT NULL,
    [DisplayName]                NVARCHAR (50)  NOT NULL,
    [IsRequired]                 BIT            NOT NULL,
    [Validator]                  NVARCHAR (200) NULL,
    [Comment]                    NVARCHAR (200) NULL,
    CONSTRAINT [PK_VoucherSupplierOperationParameter_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_VoucherSupplierOperationParameter_VoucherSupplierOperation_VoucherSupplierOperationId] FOREIGN KEY ([VoucherSupplierOperationId]) REFERENCES [dbo].[VoucherSupplierOperation] ([Id])
);

