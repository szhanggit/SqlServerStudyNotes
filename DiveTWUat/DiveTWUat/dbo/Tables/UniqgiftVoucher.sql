CREATE TABLE [dbo].[UniqgiftVoucher] (
    [Id]                 BIGINT           IDENTITY (1, 1) NOT NULL,
    [ProgramCode]        VARCHAR (20)     NOT NULL,
    [VoucherId]          BIGINT           NULL,
    [ProductCode]        VARCHAR (50)     NOT NULL,
    [VendorCode]         VARCHAR (100)    NOT NULL,
    [TpcLogId]           BIGINT           NULL,
    [S_OrderNumber]      VARCHAR (50)     NOT NULL,
    [S_VoucherGuid]      UNIQUEIDENTIFIER NOT NULL,
    [S_ProgramCode]      VARCHAR (20)     NULL,
    [S_VoucherNo]        VARCHAR (50)     NOT NULL,
    [S_ExpirationDate]   DATETIME         NULL,
    [S_ShortUrl]         VARCHAR (500)    NOT NULL,
    [S_ShortUrlAuthCode] VARCHAR (100)    NOT NULL,
    CONSTRAINT [PK_UniqgiftVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_UniqgiftVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

