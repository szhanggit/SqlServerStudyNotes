CREATE TABLE [dbo].[ApiVoucherStockBook] (
    [Id]         INT          IDENTITY (1, 1) NOT NULL,
    [ProductId]  INT          NOT NULL,
    [SessionId]  VARCHAR (50) NOT NULL,
    [TableName]  VARCHAR (20) NOT NULL,
    [LockedTime] DATETIME     NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [idx_ApiVoucherStockBook_ExpiryDate]
    ON [dbo].[ApiVoucherStockBook]([Id] ASC, [LockedTime] ASC);

