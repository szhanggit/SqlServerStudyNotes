CREATE TABLE [dbo].[BUF_PreAuthorizationComplete] (
    [SessionId]                   VARCHAR (50) NOT NULL,
    [AccountNumber]               VARCHAR (50) NOT NULL,
    [ProgramId]                   INT          NOT NULL,
    [BalanceAvailable]            INT          NOT NULL,
    [BalanceFrozen]               INT          NOT NULL,
    [AccountCheckSum]             VARCHAR (50) NOT NULL,
    [ModifyVersion]               INT          NOT NULL,
    [TransactionCheckSum]         VARCHAR (50) NOT NULL,
    [SecurityKeyId]               INT          NULL,
    [TranLocalDateTime]           DATETIME     NULL,
    [TranLocalDate]               INT          NULL,
    [TranCode]                    VARCHAR (50) NOT NULL,
    [LastTranOn]                  DATETIME     NULL,
    [Status]                      INT          NOT NULL,
    [TranCodeRef]                 VARCHAR (50) NOT NULL,
    [PreviousTransactionChecksum] VARCHAR (50) NOT NULL,
    [ConsumeTime]                 DATETIME     NULL,
    [ConsumeMerchantCode]         VARCHAR (50) NULL,
    [ConsumeShopCode]             VARCHAR (50) NULL,
    [ConsumeTerminalSSN]          VARCHAR (50) NULL
);


GO
CREATE NONCLUSTERED INDEX [BUF_PreAuthorizationComplete_SessionId]
    ON [dbo].[BUF_PreAuthorizationComplete]([SessionId] ASC);

