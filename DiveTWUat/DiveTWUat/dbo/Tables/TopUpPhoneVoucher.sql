CREATE TABLE [dbo].[TopUpPhoneVoucher] (
    [Id]            BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProgramCode]   VARCHAR (20)    NOT NULL,
    [VendorCode]    VARCHAR (50)    NOT NULL,
    [VoucherId]     BIGINT          NULL,
    [ProductCode]   VARCHAR (50)    NULL,
    [Amount]        NUMERIC (20, 6) NULL,
    [TPCLogId]      BIGINT          NULL,
    [Status]        VARCHAR (50)    NULL,
    [Pin]           VARCHAR (500)   NULL,
    [SerialNumber]  VARCHAR (500)   NULL,
    [RequsetID]     VARCHAR (50)    NULL,
    [CommPerc]      NUMERIC (20, 6) NULL,
    [CommDollar]    NUMERIC (20, 6) NULL,
    [Cost]          NUMERIC (20, 6) NULL,
    [TransactionID] VARCHAR (100)   NULL,
    CONSTRAINT [PK_TopUpPhoneVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TopUpPhoneVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

