CREATE TABLE [dbo].[BonagoVoucher] (
    [Id]               BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProgramCode]      VARCHAR (20)    NOT NULL,
    [VendorCode]       VARCHAR (50)    NOT NULL,
    [ProductCode]      VARCHAR (50)    NULL,
    [Code]             VARCHAR (200)   NULL,
    [Amount]           NUMERIC (20, 6) NULL,
    [CountryCode]      VARCHAR (5)     NULL,
    [TpcLogId]         BIGINT          NULL,
    [VoucherId]        BIGINT          NULL,
    [Status]           VARCHAR (100)   NULL,
    [RetailerName]     VARCHAR (500)   NULL,
    [OrderItemClaimId] VARCHAR (500)   NULL,
    [CodesCount]       VARCHAR (100)   NULL,
    CONSTRAINT [PK_BonagoVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_BonagoVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

