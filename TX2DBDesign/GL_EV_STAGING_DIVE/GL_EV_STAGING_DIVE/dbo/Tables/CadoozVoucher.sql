CREATE TABLE [dbo].[CadoozVoucher] (
    [Id]                     BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProgramCode]            VARCHAR (20)    NOT NULL,
    [VoucherId]              BIGINT          NULL,
    [Code]                   NVARCHAR (500)  NULL,
    [Currency]               NVARCHAR (500)  NULL,
    [ECardLink]              NVARCHAR (500)  NULL,
    [EVoucherLink]           NVARCHAR (500)  NULL,
    [Pin]                    NVARCHAR (500)  NULL,
    [ProductName]            NVARCHAR (500)  NULL,
    [ProductNumber]          NVARCHAR (500)  NULL,
    [ProductVariationNumber] NVARCHAR (500)  NULL,
    [SerialNumber]           BIGINT          NULL,
    [Value]                  NUMERIC (20, 6) NULL,
    [Email]                  NVARCHAR (500)  NULL,
    [OrderNumber]            NVARCHAR (500)  NULL,
    [TPCLogId]               BIGINT          NOT NULL,
    [VendorCode]             VARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_CadoozVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_CadoozVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

