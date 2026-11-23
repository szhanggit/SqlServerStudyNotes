CREATE TABLE [dbo].[VoucherShortUrl] (
    [Id]           BIGINT       NOT NULL,
    [VoucherAlias] VARCHAR (50) NOT NULL,
    [AuthCode]     VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_VoucherShortUrl_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [UK_VoucherShortUrl_VoucherAlias] UNIQUE NONCLUSTERED ([VoucherAlias] ASC) WITH (FILLFACTOR = 90)
);

