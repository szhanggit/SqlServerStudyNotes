CREATE TABLE [dbo].[AccountLE] (
    [Id]                BIGINT       IDENTITY (1, 1) NOT NULL,
    [ProgramId]         INT          NOT NULL,
    [ProgramCode]       VARCHAR (50) NOT NULL,
    [AccountNumber]     VARCHAR (50) NOT NULL,
    [BalanceAvailable]  INT          NOT NULL,
    [FinanceExpireDays] INT          NOT NULL,
    [FinanceExpireDate] DATETIME     NULL,
    [LEStatus]          INT          NOT NULL,
    [SessionId]         VARCHAR (50) NULL,
    [InitBalance]		INT			 NULL,
	[LEInitBalance]		INT			 NULL
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [UQ_AccountNumber_ProgramId] UNIQUE NONCLUSTERED ([AccountNumber] ASC, [ProgramId] ASC) WITH (FILLFACTOR = 90, IGNORE_DUP_KEY = ON)
);


GO
CREATE NONCLUSTERED INDEX [index_AccountLE_AccountNumber_ProgramCode]
    ON [dbo].[AccountLE]([AccountNumber] ASC, [ProgramCode] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [index_AccountLE_Session]
    ON [dbo].[AccountLE]([SessionId] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [index_AccountLE_Status]
    ON [dbo].[AccountLE]([LEStatus] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [index_AccountLE_FinanceExpireDate]
    ON [dbo].[AccountLE]([FinanceExpireDate] ASC) WITH (FILLFACTOR = 90);

