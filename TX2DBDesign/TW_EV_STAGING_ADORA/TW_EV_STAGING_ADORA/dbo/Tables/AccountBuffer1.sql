CREATE TABLE [dbo].[AccountBuffer1] (
    [TaskId]                         VARCHAR (50)     NOT NULL,
    [AccountNumber]                  VARCHAR (50)     NOT NULL,
    [ProgramId]                      INT              NOT NULL,
    [ProductId]                      INT              NOT NULL,
    [ExternalOrderId]                VARCHAR (50)     NULL,
    [AccountNumberHashed]            VARCHAR (50)     NOT NULL,
    [BalanceAvailable]               INT              NOT NULL,
    [BalanceFrozen]                  INT              NOT NULL,
    [ValueType]                      INT              NOT NULL,
    [TopupMode]                      INT              NOT NULL,
    [Status]                         INT              NOT NULL,
    [Checksum]                       VARCHAR (50)     NOT NULL,
    [TranCount]                      INT              NOT NULL,
    [TranAmountAccumulated]          INT              DEFAULT ((0)) NOT NULL,
    [AcceptanceLoopId]               INT              NOT NULL,
    [RestrictionId]                  INT              NULL,
    [ExpirationPolicyId]             INT              NULL,
    [Password]                       VARCHAR (32)     NULL,
    [ActiveFrom]                     DATETIME         DEFAULT ('1900-01-01') NOT NULL,
    [ActiveTo]                       DATETIME         DEFAULT ('1900-01-01') NOT NULL,
    [CreatedOn]                      DATETIME         NOT NULL,
    [LastTranOn]                     DATETIME         NULL,
    [LastTranDate]                   INT              NULL,
    [LastTranTime]                   BIGINT           NULL,
    [BlockedOn]                      DATETIME         NULL,
    [ActivatedOn]                    DATETIME         NULL,
    [ExpiredOn]                      DATETIME         NULL,
    [ModifyVersion]                  INT              DEFAULT ((0)) NOT NULL,
    [AccountNumberLength]            TINYINT          NOT NULL,
    [AccountGUID]                    UNIQUEIDENTIFIER NULL,
    [IsNotifyClient]                 BIT              DEFAULT ((0)) NOT NULL,
    [ClientNotificationProviderCode] VARCHAR (50)     NULL,
    [ConsumeTime]                    DATETIME         NULL,
    [ConsumeMerchantCode]            VARCHAR (50)     NULL,
    [ConsumeShopCode]                VARCHAR (50)     NULL,
    [ProgramCode]                    VARCHAR (20)     NOT NULL,
    [ConsumeTerminalSSN]             VARCHAR (50)     NULL,
    [PinCode]                        VARCHAR (100)    NULL,
    [SequenceNumber]                 BIGINT           NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_AccountBuffer1_AccountNumber_ProgramId]
    ON [dbo].[AccountBuffer1]([AccountNumber] ASC, [ProgramId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_AccountBuffer1_TaskId]
    ON [dbo].[AccountBuffer1]([TaskId] ASC);

