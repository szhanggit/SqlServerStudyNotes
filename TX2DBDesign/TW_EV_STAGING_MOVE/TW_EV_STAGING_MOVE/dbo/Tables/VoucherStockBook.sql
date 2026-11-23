CREATE TABLE [dbo].[VoucherStockBook] (
    [Id]           INT          IDENTITY (1, 1) NOT NULL,
    [OrderLineId]  INT          NOT NULL,
    [SessionId]    VARCHAR (50) NOT NULL,
    [BookStatus]   INT          NOT NULL,
    [CreationTime] DATETIME     NOT NULL,
    CONSTRAINT [PK_VoucherStockBook_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

