CREATE TABLE [dbo].[AccountLETrans] (
    [AId]                  BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AccountLEId]          BIGINT       NOT NULL,
    [TranBalanceAvailable] INT          NULL,
    [TranAmount]           INT          NULL,
    [TransLEStatus]        INT          NULL,
    [TranType]             INT          NULL,
    [TranCode]             VARCHAR (50) NULL,
    [MerchantCode]         VARCHAR (50) NULL,
    [SettleDate]           INT          NULL,
    [TranLocalDate]        INT          NULL,
    [CeatedDate]           DATETIME     NULL,
    [TransSessionId]       VARCHAR (50) NULL,
    CONSTRAINT [PK_AccountLETrans] PRIMARY KEY CLUSTERED ([AId] ASC) WITH (FILLFACTOR = 90),
    FOREIGN KEY ([AccountLEId]) REFERENCES [dbo].[AccountLE] ([Id])
);

