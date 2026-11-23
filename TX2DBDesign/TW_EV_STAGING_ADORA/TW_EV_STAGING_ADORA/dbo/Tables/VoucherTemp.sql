CREATE TABLE [dbo].[VoucherTemp] (
    [Id]            INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AccountNumber] VARCHAR (50)  NULL,
    [TranCode]      VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_VoucherTemp_AccountNumber_TranCode]
    ON [dbo].[VoucherTemp]([AccountNumber] ASC, [TranCode] ASC);

