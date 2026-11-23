CREATE TABLE [dbo].[AccountLETrans_20200102] (
    [AId]                  BIGINT       IDENTITY (1, 1) NOT NULL,
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
    [TransSessionId]       VARCHAR (50) NULL
);

