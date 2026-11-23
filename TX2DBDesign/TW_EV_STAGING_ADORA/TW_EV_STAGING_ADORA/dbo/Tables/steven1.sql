CREATE TABLE [dbo].[steven1] (
    [AccountNumber]    VARCHAR (50) NOT NULL,
    [ProgramId]        INT          NOT NULL,
    [BalanceAvailable] INT          NOT NULL,
    [ActivatedOn]      DATETIME     NOT NULL,
    [TranType]         INT          NOT NULL,
    [SessionId]        VARCHAR (50) NULL,
    [TranCodeRef]      VARCHAR (50) NULL,
    [MerchantCode]     VARCHAR (50) NULL,
    [TranLocalDate]    INT          NULL
);

