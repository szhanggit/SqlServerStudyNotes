CREATE TABLE [dbo].[VoucherGuidBuffer] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [VoucherGuid] VARCHAR (100) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
    [SessionId]   VARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_vgb_voucherguid]
    ON [dbo].[VoucherGuidBuffer]([VoucherGuid] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_vgb_sessionid]
    ON [dbo].[VoucherGuidBuffer]([SessionId] ASC);

