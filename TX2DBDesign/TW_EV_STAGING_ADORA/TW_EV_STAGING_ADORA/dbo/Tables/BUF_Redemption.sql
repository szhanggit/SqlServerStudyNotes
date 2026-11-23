CREATE TABLE [dbo].[BUF_Redemption] (
    [AccountNumber]       VARCHAR (50) NULL,
    [ProgramId]           INT          NULL,
    [BalanceAvailable]    INT          NULL,
    [BalanceFrozen]       INT          NULL,
    [AccountCheckSum]     VARCHAR (50) NULL,
    [ModifyVersion]       INT          NULL,
    [Status]              INT          NULL,
    [LastTranOn]          DATETIME     NULL,
    [ConsumeTime]         DATETIME     NULL,
    [ConsumeMerchantCode] VARCHAR (50) NULL,
    [ConsumeShopCode]     VARCHAR (50) NULL,
    [ConsumeTerminalSSN]  VARCHAR (50) NULL,
    [TranCode]            VARCHAR (50) NULL,
    [TranLocalDate]       INT          NULL,
    [TranLocalDateTime]   DATETIME     NULL,
    [TransactionCheckSum] VARCHAR (50) NULL,
    [SecurityKeyId]       INT          NULL,
    [SessionId]           VARCHAR (50) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [BUF_Redemption_SessionId]
    ON [dbo].[BUF_Redemption]([SessionId] ASC);

