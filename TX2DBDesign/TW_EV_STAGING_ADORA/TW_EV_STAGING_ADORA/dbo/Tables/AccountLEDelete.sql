CREATE TABLE [dbo].[AccountLEDelete] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [AccountLEId]       INT            NULL,
    [ProgramId]         INT            NULL,
    [ProgramCode]       VARCHAR (50)   NULL,
    [AccountNumber]     VARCHAR (50)   NULL,
    [BalanceAvailable]  INT            NULL,
    [FinanceExpireDays] INT            NULL,
    [FinanceExpireDate] DATETIME       NULL,
    [LEStatus]          INT            NULL,
    [SessionId]         VARCHAR (50)   NULL,
    [LEInitBalance]     INT            NULL,
    [InitBalance]       INT            NULL,
    [BackupOn]          DATETIME       NULL,
    [Channel]           VARCHAR (100)  NULL,
    [Comment]           VARCHAR (1000) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

