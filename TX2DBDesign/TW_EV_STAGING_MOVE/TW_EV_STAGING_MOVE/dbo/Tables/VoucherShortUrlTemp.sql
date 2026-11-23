CREATE TABLE [dbo].[VoucherShortUrlTemp] (
    [SessionId]    VARCHAR (50) NOT NULL,
    [Id]           BIGINT       NOT NULL,
    [VoucherAlias] VARCHAR (20) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
    [AuthCode]     VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_VoucherShortUrlTempl_Id] UNIQUE NONCLUSTERED ([Id] ASC),
    CONSTRAINT [UK_VoucherShortUrlTemp_VoucherAlias] UNIQUE NONCLUSTERED ([VoucherAlias] ASC)
);

