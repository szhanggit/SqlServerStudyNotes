CREATE TABLE [dbo].[AccountBuffer3] (
    [AccountCheckSum]     VARCHAR (50) NULL,
    [Status]              INT          NULL,
    [LastTranOn]          DATETIME     NULL,
    [ActiveFrom]          DATETIME     NULL,
    [ActiveTo]            DATETIME     NULL,
    [ActivatedOn]         DATETIME     NULL,
    [AccountNumber]       VARCHAR (50) NULL,
    [ModifyVersion]       INT          NULL,
    [ProgramId]           INT          NULL,
    [MerchantCode]        VARCHAR (50) NULL,
    [TranUtcDateTimeL]    BIGINT       NULL,
    [HostSsn]             VARCHAR (12) NULL,
    [TerminalSSN]         VARCHAR (50) NULL,
    [TranType]            SMALLINT     NULL,
    [TranAmount]          INT          NULL,
    [SecurityKeyId]       INT          NULL,
    [TransactionChecksum] VARCHAR (50) NULL,
    [TranLocalDateTime]   DATETIME     NULL,
    [TranLocalDate]       INT          NULL,
    [SessionId]           VARCHAR (50) NULL,
    [SequenceNumber]      BIGINT       NULL,
    [ShopCode]            VARCHAR (50) NULL
);


GO
CREATE NONCLUSTERED INDEX [index_AccountBuffer3_SessionId_AccountNumber]
    ON [dbo].[AccountBuffer3]([SessionId] ASC, [AccountNumber] ASC)
    INCLUDE([AccountCheckSum], [Status], [LastTranOn], [ActiveFrom], [ActiveTo], [ActivatedOn], [ModifyVersion], [ProgramId], [MerchantCode], [TranUtcDateTimeL], [HostSsn], [TerminalSSN], [TranType], [TranAmount], [SecurityKeyId], [TransactionChecksum], [TranLocalDateTime], [TranLocalDate]);

