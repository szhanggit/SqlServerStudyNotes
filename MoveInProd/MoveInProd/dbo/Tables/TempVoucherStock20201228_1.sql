CREATE TABLE [dbo].[TempVoucherStock20201228] (
    [Id]            INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VoucherNumber] VARCHAR (50) NULL,
    [SessionId]     VARCHAR (50) NULL,
    [StockStatus]   INT          NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

