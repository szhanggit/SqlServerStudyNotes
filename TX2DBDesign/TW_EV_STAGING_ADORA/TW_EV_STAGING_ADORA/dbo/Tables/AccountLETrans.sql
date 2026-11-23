CREATE TABLE [dbo].[AccountLETrans] (
    [AId]                  BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AccountLEId]          BIGINT       NOT NULL,
    [TranBalanceAvailable] INT          NULL,
    [TransLEStatus]        INT          NULL,
    [TranType]             INT          NULL,
    [TranCode]             VARCHAR (50) NULL,
    [CeatedDate]           DATETIME     NULL,
    [TransSessionId]       VARCHAR (50) NULL,
    [TranAmount]           INT          NULL,
    [MerchantCode]         VARCHAR (50) NULL,
    [SettleDate]           INT          NULL,
    [TranLocalDate]        INT          NULL,
    CONSTRAINT [PK_AccountLETrans] PRIMARY KEY CLUSTERED ([AId] ASC),
    FOREIGN KEY ([AccountLEId]) REFERENCES [dbo].[AccountLE] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [index_AccountLETrans_AccountLEId]
    ON [dbo].[AccountLETrans]([AccountLEId] ASC);


GO
CREATE NONCLUSTERED INDEX [index_AccountLETrans_TransLEStatus]
    ON [dbo].[AccountLETrans]([TransLEStatus] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-AccountLETrans-Status]
    ON [dbo].[AccountLETrans]([TransLEStatus] ASC)
    INCLUDE([AccountLEId], [TranBalanceAvailable], [TranAmount]);

