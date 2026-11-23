CREATE TABLE [dbo].[BUF_ReversePreAuthorization] (
    [SessionId]            VARCHAR (50) NOT NULL,
    [AccountNumber]        VARCHAR (50) NOT NULL,
    [ProgramId]            INT          NOT NULL,
    [BalanceAvailable]     INT          NOT NULL,
    [BalanceFrozen]        INT          NOT NULL,
    [AccountCheckSum]      VARCHAR (50) NOT NULL,
    [ModifyVersion]        INT          NOT NULL,
    [TransactionCheckSum]  VARCHAR (50) NOT NULL,
    [SecurityKeyId]        INT          NULL,
    [TranLocalDateTime]    DATETIME     NULL,
    [TranLocalDate]        INT          NULL,
    [TranCode]             VARCHAR (50) NOT NULL,
    [ReversedTranCheckSum] VARCHAR (50) NOT NULL,
    [ReversedTranCode]     VARCHAR (50) NOT NULL,
    [TranCodeRef]          VARCHAR (50) NOT NULL,
    [LastTranOn]           DATETIME     NULL
);


GO
CREATE NONCLUSTERED INDEX [BUF_ReversePreAuthorization_SessionId]
    ON [dbo].[BUF_ReversePreAuthorization]([SessionId] ASC);

