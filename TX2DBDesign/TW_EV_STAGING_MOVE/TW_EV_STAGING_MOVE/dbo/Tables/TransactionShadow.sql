CREATE TABLE [dbo].[TransactionShadow] (
    [Id]              INT             IDENTITY (1, 1) NOT NULL,
    [TransactionId]   INT             NULL,
    [AccountNumber]   VARCHAR (50)    NULL,
    [TrAccountNumber] VARCHAR (50)    NULL,
    [TranCode]        VARCHAR (50)    NULL,
    [TrTranCode]      VARCHAR (50)    NULL,
    [TranCodeRef]     VARCHAR (50)    NULL,
    [NWR]             NUMERIC (20, 6) NULL,
    [TRNWR]           NUMERIC (20, 6) NULL,
    [TranType]        SMALLINT        NOT NULL,
    [TRTranType]      SMALLINT        NOT NULL,
    [ResponseCode]    VARCHAR (5)     NULL,
    [TRResponseCode]  VARCHAR (5)     NULL,
    [Status]          TINYINT         NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

