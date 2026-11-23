CREATE TABLE [dbo].[TempOut] (
    [Id]                BIGINT       NOT NULL,
    [ProgramId]         INT          NOT NULL,
    [ProgramCode]       VARCHAR (50) NOT NULL,
    [AccountNumber]     VARCHAR (50) NOT NULL,
    [BalanceAvailable]  INT          NOT NULL,
    [FinanceExpireDays] INT          NOT NULL,
    [FinanceExpireDate] DATETIME     NULL,
    [LEStatus]          INT          NOT NULL,
    [SessionId]         VARCHAR (50) NULL,
    [InitBalance]       VARCHAR (50) NULL
);

