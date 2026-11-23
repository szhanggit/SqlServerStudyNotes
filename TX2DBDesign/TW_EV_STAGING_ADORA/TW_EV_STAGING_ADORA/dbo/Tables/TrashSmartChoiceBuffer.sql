CREATE TABLE [dbo].[TrashSmartChoiceBuffer] (
    [AccountCheckSum]            VARCHAR (50) NULL,
    [AccountNumber]              VARCHAR (50) NULL,
    [ProgramId]                  INT          NULL,
    [ProgramCode]                VARCHAR (20) NULL,
    [ModifyVersion]              INT          NULL,
    [IsAccountHistory]           BIT          NULL,
    [RedeemedTranChecksum]       VARCHAR (50) NULL,
    [RedeemedTranRefundedAmount] INT          NULL,
    [RedeemedTranCode]           VARCHAR (50) NULL,
    [TranCodeRef]                VARCHAR (50) NULL,
    [IsTranHistory]              BIT          NULL,
    [TranCode]                   VARCHAR (50) NOT NULL,
    [BalanceAvailable]           INT          NOT NULL,
    [BalanceFrozen]              INT          NOT NULL,
    [TerminalSSN]                VARCHAR (50) NOT NULL,
    [MerchantCode]               VARCHAR (50) NOT NULL,
    [TranUtcDate]                INT          NOT NULL,
    [TranUtcDateTime]            DATETIME     NOT NULL,
    [TranUtcDateTimeL]           BIGINT       NOT NULL,
    [HostSsn]                    VARCHAR (12) NOT NULL,
    [TranType]                   SMALLINT     NOT NULL,
    [TranAmount]                 INT          NOT NULL,
    [SecurityKeyId]              INT          NOT NULL,
    [TransactionChecksum]        VARCHAR (50) NOT NULL,
    [TranLocalDateTime]          DATETIME     NOT NULL,
    [TranLocalDate]              INT          NOT NULL,
    [CallerIP]                   VARCHAR (50) NULL,
    [Channel]                    VARCHAR (20) NOT NULL,
    [SessionId]                  VARCHAR (50) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [index_TrashSmartChoiceBuffer_SessionId]
    ON [dbo].[TrashSmartChoiceBuffer]([SessionId] ASC);

