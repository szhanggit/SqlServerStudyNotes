CREATE TABLE [dbo].[YouGotAGiftVoucher] (
    [Id]              BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProgramCode]     VARCHAR (20)    NOT NULL,
    [VoucherId]       BIGINT          NULL,
    [VoucherLink]     VARCHAR (500)   NULL,
    [ValidityEndDate] VARCHAR (50)    NULL,
    [ProductCode]     VARCHAR (50)    NULL,
    [CardCode]        VARCHAR (50)    NULL,
    [Amount]          NUMERIC (20, 6) NULL,
    [TPCLogId]        BIGINT          NULL,
    [CurrencyCode]    VARCHAR (10)    NULL,
    [OrderId]         VARCHAR (50)    NULL,
    [State]           VARCHAR (10)    NULL,
    [ReferenceId]     VARCHAR (50)    NULL,
    [DeliveryType]    VARCHAR (10)    NULL,
    [PDFLink]         VARCHAR (500)   NULL,
    [VendorCode]      VARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_YouGotAGiftVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_YouGotAGiftVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

