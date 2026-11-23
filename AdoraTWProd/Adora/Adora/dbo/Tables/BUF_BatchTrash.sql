CREATE TABLE [dbo].[BUF_BatchTrash] (
    [AccountNumber]              VARCHAR (50) NULL,
    [ProgramId]                  INT          NULL,
    [ProgramCode]                VARCHAR (20) NULL,
    [MerchantCode]               VARCHAR (50) NULL,
    [TranUtcDateTime]            DATETIME     NULL,
    [TranUtcDateTimeL]           BIGINT       NULL,
    [TerminalSSN]                VARCHAR (50) NULL,
    [HostSSN]                    VARCHAR (12) NULL,
    [TranAmount]                 INT          NULL,
    [CallerIP]                   VARCHAR (50) NULL,
    [TranUtcDate]                INT          NULL,
    [TranLocalDateTime]          DATETIME     NULL,
    [TranLocalDate]              INT          NULL,
    [TransactionChecksum]        VARCHAR (50) NULL,
    [SecurityKeyId]              INT          NULL,
    [SessionId]                  VARCHAR (50) NULL,
    [ModifyVersion]              INT          NULL,
    [AccountCheckSum]            VARCHAR (50) NULL,
    [TranType]                   SMALLINT     NULL,
    [Status]                     TINYINT      NULL,
    [TransactionStatus]          TINYINT      NULL,
    [RefundedAmount]             INT          NULL,
    [BalanceAvailable]           INT          NULL,
    [BalanceFrozen]              INT          NULL,
    [ResponseCode]               VARCHAR (5)  NULL,
    [Channel]                    VARCHAR (20) NULL,
    [TranCodeRef]                VARCHAR (50) NULL,
    [IsTranHistory]              BIT          NULL,
    [IsAccountHistory]           BIT          NULL,
    [RedeemedTranChecksum]       VARCHAR (50) NULL,
    [RedeemedTranRefundedAmount] INT          NULL,
    [TranCode]                   VARCHAR (50) NULL,
    [AdditionalTranAmount]       INT          DEFAULT ((0)) NULL
);


GO
CREATE NONCLUSTERED INDEX [index_BUF_BatchTrash_SessionId]
    ON [dbo].[BUF_BatchTrash]([SessionId] ASC) WITH (FILLFACTOR = 90);

