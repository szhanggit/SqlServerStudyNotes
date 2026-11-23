CREATE TABLE [dbo].[VoucherShortUrlBuffer] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [ShortUrl]  VARCHAR (100) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
    [SessionId] VARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_vsub_shorturl]
    ON [dbo].[VoucherShortUrlBuffer]([ShortUrl] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_vsub_sessionid]
    ON [dbo].[VoucherShortUrlBuffer]([SessionId] ASC);

