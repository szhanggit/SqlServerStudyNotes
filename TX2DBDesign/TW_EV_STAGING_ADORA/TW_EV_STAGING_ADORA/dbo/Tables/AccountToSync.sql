CREATE TABLE [dbo].[AccountToSync] (
    [AccountNumber]       VARCHAR (50) NOT NULL,
    [ProgramId]           INT          NOT NULL,
    [BalanceAvailable]    INT          NOT NULL,
    [BalanceFrozen]       INT          NOT NULL,
    [Status]              INT          NOT NULL,
    [CreatedOn]           DATETIME     NOT NULL,
    [ActiveTo]            DATETIME     NULL,
    [ActivatedOn]         DATETIME     NULL,
    [ConsumeTime]         DATETIME     NULL,
    [ConsumeMerchantCode] VARCHAR (50) NULL,
    [ConsumeShopCode]     VARCHAR (50) NULL,
    [ChangedUTCTimeL]     BIGINT       NULL,
    [ChangedTimestamp]    ROWVERSION   NULL,
    [ConsumeTerminalSSN]  VARCHAR (50) NULL,
    [LastTranOn]          DATETIME     NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_AccountToSync_ChangedUTCTimeL]
    ON [dbo].[AccountToSync]([ChangedUTCTimeL] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_AccountToSync_AccountNumber_ProgramId]
    ON [dbo].[AccountToSync]([AccountNumber] ASC, [ProgramId] ASC);

