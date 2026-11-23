CREATE TABLE [dbo].[AccountLEBuffer] (
    [AccountNumber]    VARCHAR (50) NOT NULL,
    [ProgramId]        INT          NOT NULL,
    [BalanceAvailable] INT          NOT NULL,
    [ActivatedOn]      DATETIME     NOT NULL,
    [TranType]         INT          NOT NULL,
    [SessionId]        VARCHAR (50) NULL,
    [TranCodeRef]      VARCHAR (50) NULL,
    [MerchantCode]     VARCHAR (50) NULL,
    [TranLocalDate]    INT          NULL,
    CONSTRAINT [UQ_AccountLEBuffer_AccountNumber_ProgramId] UNIQUE NONCLUSTERED ([AccountNumber] ASC, [ProgramId] ASC) WITH (FILLFACTOR = 90, IGNORE_DUP_KEY = ON)
);


GO
CREATE NONCLUSTERED INDEX [index_AccountLEBuffer_SessionId]
    ON [dbo].[AccountLEBuffer]([SessionId] ASC) WITH (FILLFACTOR = 90);

