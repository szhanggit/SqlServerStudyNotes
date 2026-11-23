CREATE TABLE [dbo].[TransactionTemp_20200709] (
    [AccountNumber]              VARCHAR (50)     NOT NULL,
    [ProgramCode]                VARCHAR (20)     NOT NULL,
    [MerchantCode]               VARCHAR (50)     NOT NULL,
    [HostSSN]                    VARCHAR (12)     NOT NULL,
    [TerminalSSN]                VARCHAR (50)     NOT NULL,
    [TranUtcDateTimeL]           BIGINT           NOT NULL,
    [TranUtcDateTime]            DATETIME         NOT NULL,
    [TranLocalDate]              INT              NULL,
    [TranLocalDateTime]          DATETIME         NULL,
    [TranTerminalDateTime]       DATETIME         NULL,
    [ShopCode]                   VARCHAR (50)     NULL,
    [TerminalCode]               VARCHAR (50)     NULL,
    [TranType]                   SMALLINT         NOT NULL,
    [Status]                     TINYINT          NOT NULL,
    [TranAmount]                 INT              NOT NULL,
    [RefundedAmount]             INT              NOT NULL,
    [ResponseCode]               VARCHAR (5)      NULL,
    [IsCleared]                  INT              NOT NULL,
    [NodeNum]                    INT              NULL,
    [CallerIP]                   VARCHAR (50)     NULL,
    [Channel]                    VARCHAR (20)     NULL,
    [Parameters]                 NVARCHAR (4000)  NULL,
    [TranCode]                   VARCHAR (50)     NOT NULL,
    [TranCodeRef]                VARCHAR (50)     NULL,
    [TranGUID]                   UNIQUEIDENTIFIER NOT NULL,
    [TranGUIDRef]                UNIQUEIDENTIFIER NULL,
    [ModifyVersion]              INT              NULL,
    [BalanceAvailable]           INT              NULL,
    [BalanceFrozen]              INT              NULL,
    [Checksum]                   VARCHAR (50)     NULL,
    [SecurityKeyId]              INT              NULL,
    [Rsv1]                       NVARCHAR (255)   NULL,
    [Rsv2]                       NVARCHAR (255)   NULL,
    [Rsv3]                       NVARCHAR (255)   NULL,
    [TranRealDateTime]           DATETIME         NOT NULL,
    [TranUtcDate]                INT              NOT NULL,
    [SettleDate]                 INT              NULL,
    [BusinessDay]                INT              NULL,
    [ShiftCode]                  VARCHAR (50)     NULL,
    [MultiAccountsTransactionId] BIGINT           NULL
);


GO
CREATE CLUSTERED INDEX [ClusteredIndex-20200709-171945]
    ON [dbo].[TransactionTemp_20200709]([TranCode] ASC, [AccountNumber] ASC);

