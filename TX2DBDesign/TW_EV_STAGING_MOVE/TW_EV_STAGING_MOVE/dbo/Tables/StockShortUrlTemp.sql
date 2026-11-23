CREATE TABLE [dbo].[StockShortUrlTemp] (
    [Id]           BIGINT       IDENTITY (1, 1) NOT NULL,
    [SessionId]    VARCHAR (50) NULL,
    [VoucherId]    BIGINT       NOT NULL,
    [VoucherAlias] VARCHAR (20) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
    [AuthCode]     VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_StockShortUrlTemp_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

