CREATE TABLE [dbo].[GhostVoucherTransaction] (
    [Id]                INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AccountNumber]     VARCHAR (50)  NOT NULL,
    [TranCode]          VARCHAR (100) NOT NULL,
    [TranType]          INT           NULL,
    [TranUtcDate]       INT           NULL,
    [TranUtcDateTimeL]  BIGINT        NULL,
    [TranUtcDateTime]   DATETIME      NULL,
    [TranLocalDate]     INT           NULL,
    [TranLocalDateTime] DATETIME      NULL,
    [CreatedDate]       DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-GVT-VoucherNumberTranCode]
    ON [dbo].[GhostVoucherTransaction]([AccountNumber] ASC, [TranCode] ASC);

