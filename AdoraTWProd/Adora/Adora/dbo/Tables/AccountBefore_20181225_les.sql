CREATE TABLE [dbo].[AccountBefore_20181225_les] (
    [AccountNumber]        VARCHAR (50) NOT NULL,
    [ProgramCode]          VARCHAR (50) NOT NULL,
    [AId]                  BIGINT       NOT NULL,
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

