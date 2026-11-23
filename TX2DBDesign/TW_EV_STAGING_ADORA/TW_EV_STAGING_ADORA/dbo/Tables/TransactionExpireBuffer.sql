CREATE TABLE [dbo].[TransactionExpireBuffer] (
    [SessionId]         VARCHAR (50) NOT NULL,
    [AccountNumber]     VARCHAR (50) NOT NULL,
    [ProgramId]         INT          NOT NULL,
    [ProgramCode]       VARCHAR (20) NOT NULL,
    [TranUtcDate]       INT          NOT NULL,
    [TranUtcDateTimeL]  BIGINT       NOT NULL,
    [TranUtcDateTime]   DATETIME     NOT NULL,
    [TranLocalDate]     INT          NULL,
    [TranLocalDateTime] DATETIME     NULL,
    [TranRealDateTime]  DATETIME     NOT NULL,
    [TranAmount]        INT          NOT NULL,
    [ModifyVersion]     INT          NULL,
    [BalanceAvailable]  INT          NULL,
    [BalanceFrozen]     INT          NULL,
    [Checksum]          VARCHAR (50) NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_TransactionExpireBuffer_AccountNumber_ProgramId]
    ON [dbo].[TransactionExpireBuffer]([AccountNumber] ASC, [ProgramId] ASC);

