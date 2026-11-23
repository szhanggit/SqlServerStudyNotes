CREATE TABLE [dbo].[VoucherShortUrlTemp] (
    [SessionId]    VARCHAR (50) NOT NULL,
    [Id]           BIGINT       NOT NULL,
    [VoucherAlias] VARCHAR (50) NOT NULL,
    [AuthCode]     VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_VoucherShortUrlTempl_Id] UNIQUE NONCLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [UK_VoucherShortUrlTemp_VoucherAlias] UNIQUE NONCLUSTERED ([VoucherAlias] ASC) WITH (FILLFACTOR = 90)
);

