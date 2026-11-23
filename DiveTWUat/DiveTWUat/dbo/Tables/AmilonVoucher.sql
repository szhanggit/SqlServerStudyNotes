CREATE TABLE [dbo].[AmilonVoucher] (
    [Id]                BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProgramCode]       VARCHAR (20)    NOT NULL,
    [VoucherId]         BIGINT          NULL,
    [VoucherLink]       VARCHAR (500)   NULL,
    [ValidityStartDate] DATETIME        NULL,
    [ValidityEndDate]   DATETIME        NULL,
    [ProductCode]       VARCHAR (50)    NULL,
    [CardCode]          VARCHAR (50)    NULL,
    [RetailerCode]      VARCHAR (50)    NULL,
    [RetailerName]      NVARCHAR (200)  NULL,
    [Name]              NVARCHAR (200)  NULL,
    [Surname]           NVARCHAR (200)  NULL,
    [Email]             VARCHAR (50)    NULL,
    [Dedication]        NVARCHAR (200)  NULL,
    [OrderFrom]         NVARCHAR (200)  NULL,
    [OrderTo]           NVARCHAR (200)  NULL,
    [Amount]            NUMERIC (20, 6) NULL,
    [TPCLogId]          BIGINT          NOT NULL,
    [VendorCode]        VARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_AmilonVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_AmilonVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

