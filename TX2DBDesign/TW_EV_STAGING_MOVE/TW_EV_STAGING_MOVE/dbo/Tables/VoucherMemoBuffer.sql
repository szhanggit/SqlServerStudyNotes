CREATE TABLE [dbo].[VoucherMemoBuffer] (
    [Id]          INT             IDENTITY (1, 1) NOT NULL,
    [VoucherGuid] VARCHAR (100)   COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
    [Memo]        NVARCHAR (1000) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
    [SessionId]   VARCHAR (100)   NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_vmb_voucherguid]
    ON [dbo].[VoucherMemoBuffer]([VoucherGuid] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_vmb_sessionid]
    ON [dbo].[VoucherMemoBuffer]([SessionId] ASC);

