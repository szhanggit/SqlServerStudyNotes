CREATE TABLE [dbo].[VoucherSyncBuffer] (
    [ProgramCode]         VARCHAR (20) NOT NULL,
    [VoucherNumber]       VARCHAR (50) NOT NULL,
    [BalanceAvailable]    INT          NOT NULL,
    [BalanceFrozen]       INT          DEFAULT ((0)) NOT NULL,
    [Status]              INT          NOT NULL,
    [PublishedOn]         DATETIME     NULL,
    [ActivatedOn]         DATETIME     NULL,
    [ExpiryDate]          DATETIME     NULL,
    [ConsumeTime]         DATETIME     NULL,
    [ConsumeMerchantCode] VARCHAR (50) NULL,
    [ConsumeShopCode]     VARCHAR (50) NULL,
    [ConsumeTerminalSSN]  VARCHAR (50) NULL,
    [LastTranOn]          DATETIME     NULL
);

