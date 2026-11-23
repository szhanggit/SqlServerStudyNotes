CREATE TABLE [dbo].[VoucherSupplier] (
    [Id]          INT            NOT NULL,
    [Name]        NVARCHAR (50)  NOT NULL,
    [CallSetting] NVARCHAR (MAX) NULL,
    [IsExclusive] BIT            NOT NULL,
    CONSTRAINT [PK_VoucherSupplier_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

