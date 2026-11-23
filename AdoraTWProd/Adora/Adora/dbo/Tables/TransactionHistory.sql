CREATE TABLE [dbo].[TransactionHistory] (
    [AccountNumber]              VARCHAR (50)     NOT NULL,
    [ProgramCode]                VARCHAR (20)     NOT NULL,
    [MerchantCode]               VARCHAR (50)     NOT NULL,
    [HostSSN]                    VARCHAR (12)     NOT NULL,
    [TerminalSSN]                VARCHAR (50)     NOT NULL,
    [TranUtcDate]                INT              NOT NULL,
    [TranUtcDateTimeL]           BIGINT           NOT NULL,
    [TranUtcDateTime]            DATETIME         NOT NULL,
    [TranLocalDate]              INT              NULL,
    [TranLocalDateTime]          DATETIME         NULL,
    [TranTerminalDateTime]       DATETIME         NULL,
    [SettleDate]                 INT              NULL,
    [TranRealDateTime]           DATETIME         NOT NULL,
    [ShopCode]                   VARCHAR (50)     NULL,
    [TerminalCode]               VARCHAR (50)     NULL,
    [TranType]                   SMALLINT         NOT NULL,
    [Status]                     TINYINT          DEFAULT ((1)) NOT NULL,
    [TranAmount]                 INT              DEFAULT ((0)) NOT NULL,
    [RefundedAmount]             INT              DEFAULT ((0)) NOT NULL,
    [ResponseCode]               VARCHAR (5)      NULL,
    [IsCleared]                  BIT              NULL,
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
    [ShiftCode]                  VARCHAR (50)     NULL,
    [BusinessDay]                INT              NULL,
    [MultiAccountsTransactionId] BIGINT           NULL,
    CONSTRAINT [PK_TransactionHistory_AccountNumber_TranCode] PRIMARY KEY CLUSTERED ([AccountNumber] ASC, [TranCode] ASC),
    CONSTRAINT [FK_TransactionHistory_SecurityKey_SecurityKeyId] FOREIGN KEY ([SecurityKeyId]) REFERENCES [dbo].[SecurityKey] ([Id]),
    CONSTRAINT [UK_TransactionHistory_Request] UNIQUE NONCLUSTERED ([ProgramCode] ASC, [MerchantCode] ASC, [ShopCode] ASC, [TerminalCode] ASC, [TranLocalDate] ASC, [TerminalSSN] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IDX_TransactionHistory_TranType]
    ON [dbo].[TransactionHistory]([TranType] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_TransactionHistory_TranUtcDateTimeL]
    ON [dbo].[TransactionHistory]([TranUtcDateTimeL] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_TransactionHistory_TranUtcDateTimeL]
    ON [dbo].[TransactionHistory]([TranUtcDateTimeL] ASC, [ProgramCode] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'yyyymmdd', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TransactionHistory', @level2type = N'COLUMN', @level2name = N'TranUtcDateTimeL';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'UTC GMT Time', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TransactionHistory', @level2type = N'COLUMN', @level2name = N'TranUtcDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '005--Balance Inquiry
   004--Validity inquiry
   301--Issue
   401--Reverse Issue
   302--Activate
   402--Reverse Activate
   001--Redeem
   101--Reverse Redeem
   002--Pre-authorize
   102-Reverse Pre-authorize
   006--Expire Pre-authorization
   003--Pre-authorize complete
   103--Reverse pre-authorize complete
   007--Reload
   107--Reverse Reload
   303--Expire
   403--Reverse Expire', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TransactionHistory', @level2type = N'COLUMN', @level2name = N'TranType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--normal
   2--reversed
   ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TransactionHistory', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1 direct call
   2 from gateway', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TransactionHistory', @level2type = N'COLUMN', @level2name = N'Channel';

