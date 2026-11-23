CREATE TABLE [dbo].[AccountBuffer4] (
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
    [ShopCode]            VARCHAR (50) NULL,
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
    [TranCodeRef]         VARCHAR (50) NULL
);


GO
CREATE NONCLUSTERED INDEX [index_AccountBuffer4_SessionId_AccountNumber]
    ON [dbo].[AccountBuffer4]([SessionId] ASC, [AccountNumber] ASC)
    INCLUDE([AccountCheckSum], [Status], [LastTranOn], [ActiveFrom], [ActiveTo], [ActivatedOn], [ModifyVersion], [ProgramId], [MerchantCode], [ShopCode], [TranUtcDateTimeL], [HostSsn], [TerminalSSN], [TranType], [TranAmount], [SecurityKeyId], [TransactionChecksum], [TranLocalDateTime], [TranLocalDate]) WITH (FILLFACTOR = 90);

