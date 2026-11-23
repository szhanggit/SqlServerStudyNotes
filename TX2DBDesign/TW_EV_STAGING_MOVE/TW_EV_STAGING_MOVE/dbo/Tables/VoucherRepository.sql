CREATE TABLE [dbo].[VoucherRepository] (
    [VoucherNumber]       VARCHAR (50) NOT NULL,
    [VoucherNumberLength] TINYINT      NOT NULL,
    CONSTRAINT [PK_VoucherRepository_VoucherNumber] PRIMARY KEY CLUSTERED ([VoucherNumber] ASC)
);

