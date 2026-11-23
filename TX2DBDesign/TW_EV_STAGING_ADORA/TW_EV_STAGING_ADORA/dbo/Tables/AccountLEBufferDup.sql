CREATE TABLE [dbo].[AccountLEBufferDup] (
    [Id]                BIGINT       IDENTITY (1, 1) NOT NULL,
    [ProgramId]         INT          NOT NULL,
    [ProgramCode]       VARCHAR (50) NOT NULL,
    [AccountNumber]     VARCHAR (50) NOT NULL,
    [BalanceAvailable]  INT          NOT NULL,
    [FinanceExpireDays] INT          NOT NULL,
    [FinanceExpireDate] DATETIME     NULL,
    [LEStatus]          INT          NOT NULL,
    [SessionId]         VARCHAR (50) NULL,
    [LEInitBalance]     INT          NULL,
    [InitBalance]       INT          NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_AccountLEBufferDup_AccountNumber_ProgramId] UNIQUE NONCLUSTERED ([AccountNumber] ASC, [ProgramId] ASC) WITH (IGNORE_DUP_KEY = ON)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200618-171034]
    ON [dbo].[AccountLEBufferDup]([SessionId] ASC);


GO
CREATE NONCLUSTERED INDEX [index_AccountLEBufferDup_SessionId]
    ON [dbo].[AccountLEBufferDup]([SessionId] ASC);

