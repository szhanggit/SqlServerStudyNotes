CREATE TABLE [dbo].[AccountLETransDelete] (
    [Id]                   INT            IDENTITY (1, 1) NOT NULL,
    [AId]                  BIGINT         NULL,
    [AccountLEId]          BIGINT         NULL,
    [TranBalanceAvailable] INT            NULL,
    [TranAmount]           INT            NULL,
    [TransLEStatus]        INT            NULL,
    [TranType]             INT            NULL,
    [TranCode]             VARCHAR (50)   NULL,
    [MerchantCode]         VARCHAR (50)   NULL,
    [SettleDate]           INT            NULL,
    [TranLocalDate]        INT            NULL,
    [CeatedDate]           DATETIME       NULL,
    [TransSessionId]       VARCHAR (50)   NULL,
    [BackupOn]             DATETIME       NULL,
    [Channel]              VARCHAR (100)  NULL,
    [Comment]              VARCHAR (1000) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

