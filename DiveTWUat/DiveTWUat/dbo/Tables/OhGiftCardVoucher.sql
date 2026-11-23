CREATE TABLE [dbo].[OhGiftCardVoucher] (
    [Id]              BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProgramCode]     VARCHAR (20)    NOT NULL,
    [VoucherLink]     VARCHAR (500)   NULL,
    [ProductCode]     VARCHAR (50)    NULL,
    [Amount]          NUMERIC (20, 6) NULL,
    [TPCSupplierCode] VARCHAR (30)    NULL,
    [CurrencyCode]    VARCHAR (5)     NULL,
    [transactionID]   VARCHAR (500)   NULL,
    [TpcLogId]        BIGINT          NULL,
    [VoucherId]       BIGINT          NULL,
    CONSTRAINT [PK_OhGiftCardVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_OhGiftCardVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

