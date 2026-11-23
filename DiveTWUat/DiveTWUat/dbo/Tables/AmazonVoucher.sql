CREATE TABLE [dbo].[AmazonVoucher] (
    [Id]                   BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProgramCode]          VARCHAR (20)    NOT NULL,
    [GcClaimCode]          VARCHAR (500)   NULL,
    [ValidityEndDate]      NVARCHAR (200)  NULL,
    [ProductCode]          VARCHAR (50)    NULL,
    [Amount]               NUMERIC (20, 6) NULL,
    [GcId]                 VARCHAR (100)   NULL,
    [CurrencyCode]         VARCHAR (5)     NULL,
    [TpcLogId]             BIGINT          NULL,
    [VoucherId]            BIGINT          NULL,
    [Status]               VARCHAR (100)   NULL,
    [CreateOrderRequestId] VARCHAR (100)   NULL,
    [VendorCode]           VARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_AmazonVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AmazonVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

