CREATE TABLE [dbo].[GiftawayVoucher] (
    [Id]            BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProgramCode]   VARCHAR (20)    NOT NULL,
    [VendorCode]    VARCHAR (50)    NOT NULL,
    [VoucherId]     BIGINT          NULL,
    [VoucherLink]   VARCHAR (500)   NULL,
    [ProductCode]   VARCHAR (50)    NULL,
    [Amount]        NUMERIC (20, 6) NULL,
    [TPCLogId]      BIGINT          NULL,
    [StatusCode]    VARCHAR (50)    NULL,
    [Status]        VARCHAR (50)    NULL,
    [OrderID]       VARCHAR (50)    NULL,
    [ReferenceNO]   VARCHAR (50)    NULL,
    [CreditsUsed]   NUMERIC (20, 6) NULL,
    [CreditBalance] NUMERIC (20, 6) NULL,
    CONSTRAINT [PK_GiftawayVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_GiftawayVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

