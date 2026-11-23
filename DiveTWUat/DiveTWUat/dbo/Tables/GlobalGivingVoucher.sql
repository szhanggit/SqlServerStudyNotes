CREATE TABLE [dbo].[GlobalGivingVoucher] (
    [Id]                    BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProgramCode]           VARCHAR (20)    NOT NULL,
    [VoucherLink]           VARCHAR (500)   NULL,
    [ProductCode]           VARCHAR (50)    NULL,
    [Amount]                NUMERIC (20, 6) NULL,
    [TPCSupplierCode]       VARCHAR (30)    NULL,
    [CurrencyCode]          VARCHAR (5)     NULL,
    [ExpirationDate]        VARCHAR (500)   NULL,
    [GiftCertificateNumber] VARCHAR (500)   NULL,
    [RemainingAmount]       VARCHAR (10)    NULL,
    [TpcLogId]              BIGINT          NULL,
    [VoucherId]             BIGINT          NULL,
    [AccessToken]           NVARCHAR (500)  NULL,
    CONSTRAINT [PK_GlobalGivingVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_GlobalGivingVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

