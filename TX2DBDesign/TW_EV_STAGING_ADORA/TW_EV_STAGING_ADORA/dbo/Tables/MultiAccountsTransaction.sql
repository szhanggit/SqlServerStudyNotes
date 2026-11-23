CREATE TABLE [dbo].[MultiAccountsTransaction] (
    [Id]                   BIGINT         IDENTITY (1, 1) NOT NULL,
    [ProgramCode]          VARCHAR (20)   NOT NULL,
    [MerchantCode]         VARCHAR (50)   NOT NULL,
    [TerminalSSN]          VARCHAR (50)   NOT NULL,
    [TranUtcDate]          INT            NOT NULL,
    [TranUtcDateTimeL]     BIGINT         NOT NULL,
    [TranUtcDateTime]      DATETIME       NOT NULL,
    [TranLocalDate]        INT            NOT NULL,
    [TranLocalDateTime]    DATETIME       NOT NULL,
    [TranTerminalDateTime] DATETIME       NOT NULL,
    [ShopCode]             VARCHAR (50)   NULL,
    [TerminalCode]         VARCHAR (50)   NULL,
    [ShiftCode]            VARCHAR (50)   NULL,
    [BusinessDay]          INT            NULL,
    [TranType]             SMALLINT       NOT NULL,
    [Status]               TINYINT        DEFAULT ((1)) NOT NULL,
    [ResponseCode]         VARCHAR (5)    NULL,
    [NodeNum]              INT            NULL,
    [CallerIP]             VARCHAR (50)   NULL,
    [Channel]              VARCHAR (20)   NULL,
    [Parameters]           NVARCHAR (MAX) NULL,
    [ModifyVersion]        INT            NULL,
    [Rsv1]                 NVARCHAR (255) NULL,
    [Rsv2]                 NVARCHAR (255) NULL,
    [Rsv3]                 NVARCHAR (255) NULL,
    [ShiftClearingId]      BIGINT         NULL,
    [DailyClearingId]      BIGINT         NULL,
    CONSTRAINT [PK_MultiAccountsTransaction_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_MultiAccountsTransaction_Request] UNIQUE NONCLUSTERED ([ProgramCode] ASC, [MerchantCode] ASC, [ShopCode] ASC, [TerminalCode] ASC, [TerminalSSN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_MultiAccountsTransaction]
    ON [dbo].[MultiAccountsTransaction]([MerchantCode] ASC, [BusinessDay] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'yyyymmdd', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MultiAccountsTransaction', @level2type = N'COLUMN', @level2name = N'TranUtcDateTimeL';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'UTC GMT Time', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MultiAccountsTransaction', @level2type = N'COLUMN', @level2name = N'TranUtcDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '        Redemption = 101,
           ReverseRedemption = 201,
           PreAuthorization = 102,
           ReversePreAuthorization = 202,
           PreAuthorizationComplete = 103,
           ReversePreAuthorizationComplete = 203,
           AccountVerification = 104,
           BalanceEnquiry = 105,
           PosTest = 301,
           Issue = 401,
           ReverseIssue = 501,
           Activate = 402,
           ReverseActivate = 502,
           Expire = 403,
           ReverseExpire = 503,
           Extend=504,
           PreAuthorizationExpire=106,
           Reload = 107,
           ReverseReload = 207,
           TrashMoney = 404,
           TrashNoMoney = 405', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MultiAccountsTransaction', @level2type = N'COLUMN', @level2name = N'TranType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--normal
   2--reversed
   ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MultiAccountsTransaction', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1 direct call
   2 from gateway', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MultiAccountsTransaction', @level2type = N'COLUMN', @level2name = N'Channel';

