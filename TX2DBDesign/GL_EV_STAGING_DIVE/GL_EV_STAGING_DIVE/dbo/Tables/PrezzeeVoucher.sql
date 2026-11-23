CREATE TABLE [dbo].[PrezzeeVoucher] (
    [Id]                  BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProgramCode]         VARCHAR (20)    NOT NULL,
    [VoucherId]           BIGINT          NULL,
    [VoucherLink]         VARCHAR (500)   NULL,
    [ValidityEndDate]     DATETIME        NULL,
    [ProductCode]         VARCHAR (50)    NULL,
    [CardCode]            VARCHAR (50)    NULL,
    [RetailerCode]        VARCHAR (50)    NULL,
    [RetailerName]        NVARCHAR (400)  NULL,
    [Email]               VARCHAR (50)    NULL,
    [EmailDeliveryStatus] NVARCHAR (400)  NULL,
    [VocherUrlStatus]     NVARCHAR (400)  NULL,
    [CurrencyCode]        NVARCHAR (400)  NULL,
    [Amount]              NUMERIC (20, 6) NULL,
    [CreatedOn]           DATETIME        NULL,
    [ProductThemeCode]    NVARCHAR (500)  NULL,
    [StyleCode]           NVARCHAR (500)  NULL,
    [TPCLogId]            BIGINT          NULL,
    [VendorCode]          VARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_PrezzeeVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PrezzeeVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

