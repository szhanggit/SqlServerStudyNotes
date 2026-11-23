CREATE TABLE [dbo].[Voucher] (
    [Id]            BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProgramCode]   VARCHAR (20)    NOT NULL,
    [VoucherNumber] NVARCHAR (500)  NULL,
    [ExpiryDate]    NVARCHAR (500)  NULL,
    [Status]        TINYINT         NOT NULL,
    [CreatedOn]     DATETIME        NOT NULL,
    [RequestId]     VARCHAR (50)    NOT NULL,
    [TPCLogId]      BIGINT          NULL,
    [Amount]        NUMERIC (20, 6) NULL,
    [CurrencyCode]  NVARCHAR (50)   NULL,
    [ProductCode]   VARCHAR (50)    NOT NULL,
    [Misc1]         NVARCHAR (255)  NULL,
    [Misc2]         NVARCHAR (255)  NULL,
    [Misc3]         NVARCHAR (255)  NULL,
    [Password]      NVARCHAR (255)  NULL,
    [VendorCode]    VARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_Voucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Voucher_TPCLog_TPCLogId] FOREIGN KEY ([TPCLogId]) REFERENCES [dbo].[TPCLog] ([Id]),
    CONSTRAINT [UK_Voucher_Request] UNIQUE NONCLUSTERED ([ProgramCode] ASC, [RequestId] ASC)
);

