CREATE TABLE [dbo].[StockShortUrl] (
    [Id]           BIGINT       IDENTITY (1, 1) NOT NULL,
    [VoucherId]    BIGINT       NOT NULL,
    [VoucherAlias] VARCHAR (20) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
    [AuthCode]     VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_StockShortUrl_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([VoucherAlias] ASC) WITH (IGNORE_DUP_KEY = ON)
);

