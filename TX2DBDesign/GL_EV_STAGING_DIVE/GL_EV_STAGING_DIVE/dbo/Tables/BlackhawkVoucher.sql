CREATE TABLE [dbo].[BlackhawkVoucher] (
    [Id]                  BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProgramCode]         VARCHAR (20)    NOT NULL,
    [VoucherId]           BIGINT          NULL,
    [TransactionId]       NVARCHAR (500)  NULL,
    [IsCompleted]         BIT             NULL,
    [PercentComplete]     INT             NULL,
    [Success]             BIT             NULL,
    [OrderNumber]         NVARCHAR (500)  NULL,
    [ContentProviderCode] NVARCHAR (500)  NULL,
    [TransactionAmount]   NUMERIC (20, 6) NULL,
    [CardNumber]          NVARCHAR (500)  NULL,
    [Pin]                 NVARCHAR (500)  NULL,
    [Url]                 NVARCHAR (500)  NULL,
    [BarCodeValue]        NVARCHAR (500)  NULL,
    [ExpirationDate]      NVARCHAR (500)  NULL,
    [TPCLogId]            BIGINT          NOT NULL,
    [VendorCode]          VARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_BlackhawkVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_BlackhawkVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

