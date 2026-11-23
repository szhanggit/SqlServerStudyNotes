CREATE TABLE [dbo].[BUF_ReserveRedemption] (
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
    [RefundedAmount]       INT          NOT NULL,
    [Status]               INT          NOT NULL,
    [LastTranOn]           DATETIME     NULL,
    [CountDecrease]        BIT          NOT NULL,
    [AmountDecrease]       BIT          NOT NULL
);

