CREATE TABLE [dbo].[TransactionTemp] (
    [AccountNumber]     VARCHAR (50)   NOT NULL,
    [ProgramCode]       VARCHAR (20)   NOT NULL,
    [MerchantCode]      VARCHAR (50)   NOT NULL,
    [ShopCode]          VARCHAR (50)   NULL,
    [TranType]          SMALLINT       NOT NULL,
    [TranLocalDate]     INT            NULL,
    [TranLocalDateTime] DATETIME       NULL,
    [SettleDate]        INT            NULL,
    [TranRealDateTime]  DATETIME       NOT NULL,
    [Status]            TINYINT        DEFAULT ((1)) NOT NULL,
    [TranAmount]        INT            DEFAULT ((0)) NOT NULL,
    [RefundedAmount]    INT            DEFAULT ((0)) NOT NULL,
    [ResponseCode]      VARCHAR (5)    NULL,
    [Channel]           VARCHAR (20)   NULL,
    [TranCode]          VARCHAR (50)   NOT NULL,
    [TranCodeRef]       VARCHAR (50)   NULL,
    [BalanceAvailable]  INT            NULL,
    [BalanceFrozen]     INT            NULL,
    [Rsv1]              NVARCHAR (255) NULL,
    [Rsv2]              NVARCHAR (255) NULL,
    [Rsv3]              NVARCHAR (255) NULL,
    [TerminalSSN]       VARCHAR (50)   NULL,
    [ShiftCode]         VARCHAR (50)   NULL,
    [BusinessDay]       INT            NULL,
    [TerminalCode]      VARCHAR (50)   NULL,
    [PreTranType]       INT            NULL,
    [InitBalance]       INT            NULL,
    [LEBalance]         INT            NULL,
    [LEInitBalance]     INT            NULL,
    CONSTRAINT [PK_AccountNumber_TranCode] PRIMARY KEY CLUSTERED ([AccountNumber] ASC, [TranCode] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'        Redemption = 101,
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
           TrashNoMoney = 405', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TransactionTemp', @level2type = N'COLUMN', @level2name = N'TranType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1--normal
   2--reversed
   ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TransactionTemp', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 direct call
   2 from gateway', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TransactionTemp', @level2type = N'COLUMN', @level2name = N'Channel';

