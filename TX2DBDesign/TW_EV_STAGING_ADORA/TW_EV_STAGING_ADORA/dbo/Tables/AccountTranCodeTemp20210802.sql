CREATE TABLE [dbo].[AccountTranCodeTemp20210802] (
    [Id]            INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VoucherNumber] VARCHAR (50)  NULL,
    [TranCode]      VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

