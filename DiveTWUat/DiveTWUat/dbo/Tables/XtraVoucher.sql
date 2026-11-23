CREATE TABLE [dbo].[XtraVoucher] (
    [Id]              BIGINT        IDENTITY (1, 1) NOT NULL,
    [ProgramCode]     VARCHAR (20)  NOT NULL,
    [TpcLogId]        BIGINT        NULL,
    [VoucherId]       BIGINT        NULL,
    [VoucherLink]     VARCHAR (500) NULL,
    [CuponID]         VARCHAR (50)  NULL,
    [ProductCode]     VARCHAR (50)  NULL,
    [TPCSupplierCode] VARCHAR (30)  NULL,
    CONSTRAINT [PK_XtraVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_XtraVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

