CREATE TABLE [dbo].[WOGIVoucher] (
    [Id]                BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProgramCode]       VARCHAR (20)    NOT NULL,
    [VoucherId]         BIGINT          NULL,
    [VoucherLink]       VARCHAR (500)   NULL,
    [ValidityStartDate] VARCHAR (50)    NULL,
    [ValidityEndDate]   VARCHAR (50)    NULL,
    [ProductCode]       VARCHAR (50)    NULL,
    [CardCode]          VARCHAR (50)    NULL,
    [ActivationUrl]     VARCHAR (50)    NULL,
    [ActivationNumber]  NVARCHAR (400)  NULL,
    [ActivationPin ]    NVARCHAR (400)  NULL,
    [Surname]           NVARCHAR (400)  NULL,
    [Email]             VARCHAR (50)    NULL,
    [Dedication]        NVARCHAR (400)  NULL,
    [OrderFrom]         NVARCHAR (400)  NULL,
    [OrderTo]           NVARCHAR (400)  NULL,
    [Amount]            NUMERIC (20, 6) NULL,
    [TPCLogId]          BIGINT          NULL,
    [VendorCode]        VARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_WOGIVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_WOGIVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

