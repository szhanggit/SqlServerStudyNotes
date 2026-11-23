CREATE TABLE [dbo].[CashwaveVoucher] (
    [Id]           BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProgramCode]  VARCHAR (20)    NOT NULL,
    [VendorCode]   VARCHAR (50)    NOT NULL,
    [VoucherId]    BIGINT          NULL,
    [ProductCode]  VARCHAR (50)    NULL,
    [TPCLogId]     BIGINT          NULL,
    [OrderLineRef] VARCHAR (1000)  NULL,
    [Code]         VARCHAR (500)   NULL,
    [Amount]       NUMERIC (20, 6) NULL,
    [Currency]     VARCHAR (50)    NULL,
    [RequsetID]    VARCHAR (50)    NULL,
    [NominalValue] NUMERIC (20, 6) NULL,
    [ExpiresAt]    VARCHAR (100)   NULL,
    CONSTRAINT [PK_CashwaveVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CashwaveVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

