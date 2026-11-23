CREATE TABLE [dbo].[VoucherShortUrl] (
    [Id]           BIGINT       NOT NULL,
    [VoucherAlias] VARCHAR (20) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
    [AuthCode]     VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_VoucherShortUrl_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_VoucherShortUrl_VoucherAlias] UNIQUE NONCLUSTERED ([VoucherAlias] ASC)
);

