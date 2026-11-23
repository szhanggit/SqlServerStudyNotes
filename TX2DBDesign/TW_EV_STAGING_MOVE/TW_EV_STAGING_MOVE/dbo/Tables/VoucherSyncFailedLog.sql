CREATE TABLE [dbo].[VoucherSyncFailedLog] (
    [Id]                  INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProgramCode]         VARCHAR (20)  NOT NULL,
    [VoucherNumber]       VARCHAR (50)  NOT NULL,
    [BalanceAvailable]    INT           NOT NULL,
    [BalanceFrozen]       INT           NOT NULL,
    [Status]              INT           NOT NULL,
    [PublishedOn]         DATETIME      NULL,
    [ActivatedOn]         DATETIME      NULL,
    [ExpiryDate]          DATETIME      NULL,
    [ConsumeTime]         DATETIME      NULL,
    [ConsumeMerchantCode] VARCHAR (50)  NULL,
    [ConsumeShopCode]     VARCHAR (50)  NULL,
    [ConsumeTerminalSSN]  VARCHAR (50)  NULL,
    [LastTranOn]          DATETIME      NULL,
    [CreatedDate]         DATETIME      NULL,
    [SessionId]           VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

