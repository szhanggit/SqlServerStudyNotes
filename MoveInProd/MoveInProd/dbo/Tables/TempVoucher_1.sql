CREATE TABLE [dbo].[TempVoucher] (
    [Id]            INT            IDENTITY (1, 1) NOT NULL,
    [TVIndex]       INT            NOT NULL,
    [VoucherNumber] NVARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

