CREATE TABLE [dbo].[ArchiveAccountBuffer] (
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
    [TranAmountAccumulated]          INT              NOT NULL,
    [AcceptanceLoopId]               INT              NOT NULL,
    [RestrictionId]                  INT              NULL,
    [ExpirationPolicyId]             INT              NULL,
    [Password]                       VARCHAR (16)     NULL,
    [ActiveFrom]                     DATETIME         NOT NULL,
    [ActiveTo]                       DATETIME         NOT NULL,
    [CreatedOn]                      DATETIME         NOT NULL,
    [LastTranOn]                     DATETIME         NULL,
    [BlockedOn]                      DATETIME         NULL,
    [ActivatedOn]                    DATETIME         NULL,
    [ExpiredOn]                      DATETIME         NULL,
    [ModifyVersion]                  INT              NOT NULL,
    [AccountNumberLength]            TINYINT          NOT NULL,
    [AccountGUID]                    UNIQUEIDENTIFIER NULL,
    [IsNotifyClient]                 BIT              NOT NULL,
    [ClientNotificationProviderCode] VARCHAR (50)     NULL,
    [ConsumeTime]                    DATETIME         NULL,
    [ConsumeMerchantCode]            VARCHAR (50)     NULL,
    [ConsumeShopCode]                VARCHAR (50)     NULL,
    [ConsumeTerminalSSN]             VARCHAR (50)     NULL,
    [BalanceInitialized]             INT              NOT NULL,
    [PinCode]                        VARCHAR (100)    NULL,
    [MasterAccountNumber]            VARCHAR (50)     NULL,
    [MasterRedemptionTranCode]       VARCHAR (50)     NULL,
    [MasterProgramIdentityCode]      VARCHAR (20)     NULL,
    [SequenceNumber]                 BIGINT           NULL,
    [MasterRedemptionTranAmount]     INT              NULL,
    [ExecuteStatus]                  INT              NOT NULL,
    [SessionId]                      VARCHAR (50)     NULL
);


GO
CREATE NONCLUSTERED INDEX [idx_ArchiveAccountBuffer_SessionId]
    ON [dbo].[ArchiveAccountBuffer]([SessionId] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_ArchiveAccountBuffer_ExecuteStatus]
    ON [dbo].[ArchiveAccountBuffer]([ExecuteStatus] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_ArchiveAccountBuffer_AccountNumber_ProgramId]
    ON [dbo].[ArchiveAccountBuffer]([AccountNumber] ASC, [ProgramId] ASC);

