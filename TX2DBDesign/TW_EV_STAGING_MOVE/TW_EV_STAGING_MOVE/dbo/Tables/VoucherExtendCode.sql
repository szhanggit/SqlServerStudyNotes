CREATE TABLE [dbo].[VoucherExtendCode] (
    [Id]        BIGINT        NOT NULL,
    [Barcode1]  VARCHAR (100) NULL,
    [Barcode2]  VARCHAR (100) NULL,
    [Barcode3]  VARCHAR (100) NULL,
    [Barcode4]  VARCHAR (100) NULL,
    [CreatedOn] DATETIME      NOT NULL,
    CONSTRAINT [PK_VoucherExtendCode_VoucherId] PRIMARY KEY CLUSTERED ([Id] ASC)
);

