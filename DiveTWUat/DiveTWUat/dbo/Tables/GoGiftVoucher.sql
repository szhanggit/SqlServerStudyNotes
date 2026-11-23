CREATE TABLE [dbo].[GoGiftVoucher] (
    [Id]              BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProgramCode]     VARCHAR (20)    NOT NULL,
    [VoucherLink]     VARCHAR (500)   NULL,
    [ValidityEndDate] NVARCHAR (100)  NULL,
    [ProductCode]     VARCHAR (50)    NULL,
    [Amount]          NUMERIC (20, 6) NULL,
    [TPCSupplierCode] VARCHAR (30)    NULL,
    [CodeStatus]      VARCHAR (50)    NULL,
    [Balance]         NUMERIC (20, 6) NULL,
    [CurrencyCode]    VARCHAR (5)     NULL,
    [IsComplete]      BIT             NULL,
    [SessionId]       VARCHAR (30)    NULL,
    [OrderId]         VARCHAR (30)    NULL,
    [OrderToken]      VARCHAR (50)    NULL,
    [TpcLogId]        BIGINT          NULL,
    [VoucherId]       BIGINT          NULL,
    [VendorCode]      VARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_GoGiftVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_GoGiftVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

