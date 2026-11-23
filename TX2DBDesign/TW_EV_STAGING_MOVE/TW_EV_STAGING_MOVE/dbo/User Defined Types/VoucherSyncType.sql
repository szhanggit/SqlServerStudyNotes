CREATE TYPE [dbo].[VoucherSyncType] AS TABLE (
    [ProgramCode]         VARCHAR (20) NOT NULL,
    [VoucherNumber]       VARCHAR (50) NOT NULL,
    [ActivatedOn]         DATETIME     NULL,
    [BalanceAvailable]    INT          NOT NULL,
    [BalanceFrozen]       INT          NOT NULL,
    [ExpiryDate]          DATETIME     NULL,
    [PublishedOn]         DATETIME     NULL,
    [Status]              INT          NOT NULL,
    [ConsumeTime]         DATETIME     NULL,
    [ConsumeMerchantCode] VARCHAR (50) NULL,
    [ConsumeShopCode]     VARCHAR (50) NULL,
    [ConsumeTerminalSSN]  VARCHAR (50) NULL,
    [LastTranOn]          DATETIME     NULL);

