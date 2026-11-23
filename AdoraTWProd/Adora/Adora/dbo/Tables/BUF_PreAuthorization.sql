CREATE TABLE [dbo].[BUF_PreAuthorization] (
    [SessionId]           VARCHAR (50) NOT NULL,
    [AccountNumber]       VARCHAR (50) NOT NULL,
    [ProgramId]           INT          NOT NULL,
    [BalanceAvailable]    INT          NOT NULL,
    [BalanceFrozen]       INT          NOT NULL,
    [AccountCheckSum]     VARCHAR (50) NOT NULL,
    [ModifyVersion]       INT          NOT NULL,
    [TransactionCheckSum] VARCHAR (50) NOT NULL,
    [SecurityKeyId]       INT          NULL,
    [TranLocalDateTime]   DATETIME     NULL,
    [TranLocalDate]       INT          NULL,
    [TranCode]            VARCHAR (50) NOT NULL,
    [LastTranOn]          DATETIME     NULL
);

