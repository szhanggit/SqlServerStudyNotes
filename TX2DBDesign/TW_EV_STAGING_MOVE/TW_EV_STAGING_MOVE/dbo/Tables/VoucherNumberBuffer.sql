CREATE TABLE [dbo].[VoucherNumberBuffer] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [VoucherNumber] VARCHAR (100) NOT NULL,
    [SessionId]     VARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_vnb_vouchernumber]
    ON [dbo].[VoucherNumberBuffer]([VoucherNumber] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_vnb_sessionid]
    ON [dbo].[VoucherNumberBuffer]([SessionId] ASC);

