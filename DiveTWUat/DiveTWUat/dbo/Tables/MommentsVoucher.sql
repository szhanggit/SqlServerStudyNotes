CREATE TABLE [dbo].[MommentsVoucher] (
    [Id]            BIGINT          IDENTITY (1, 1) NOT NULL,
    [ProgramCode]   VARCHAR (20)    NOT NULL,
    [ProductCode]   VARCHAR (50)    NULL,
    [VendorCode]    VARCHAR (50)    NOT NULL,
    [VoucherId]     BIGINT          NULL,
    [Amount]        NUMERIC (20, 6) NULL,
    [TPCLogId]      BIGINT          NULL,
    [Status]        VARCHAR (50)    NULL,
    [MommentsID]    BIGINT          NULL,
    [OrderNumber]   VARCHAR (500)   NULL,
    [StatusOfOrder] VARCHAR (500)   NULL,
    [TypeofOrder]   VARCHAR (500)   NULL,
    [Client]        VARCHAR (500)   NULL,
    [GiftCard]      NVARCHAR (MAX)  NULL,
    [ValidFrom]     VARCHAR (500)   NULL,
    [ValidTo]       VARCHAR (500)   NULL,
    [Url]           NVARCHAR (MAX)  NULL,
    [Token]         VARCHAR (500)   NULL,
    CONSTRAINT [PK_MommentsVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_MommentsVoucher_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

