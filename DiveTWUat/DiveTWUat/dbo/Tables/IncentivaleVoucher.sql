CREATE TABLE [dbo].[IncentivaleVoucher] (
    [Id]              BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProgramCode]     VARCHAR (20)    NOT NULL,
    [VoucherId]       BIGINT          NULL,
    [ProductCode]     VARCHAR (50)    NULL,
    [Amount]          NUMERIC (20, 6) NULL,
    [TPCLogId]        BIGINT          NULL,
    [RequsetID]       VARCHAR (50)    NULL,
    [CardCode]        NVARCHAR (MAX)  NULL,
    [Availability]    VARCHAR (10)    NULL,
    [ValidityEndDate] NVARCHAR (50)   NULL,
    [MessageReturn]   NVARCHAR (2000) NULL,
    [Access_Token]    NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_IncentivaleVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_IncentivaleVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

