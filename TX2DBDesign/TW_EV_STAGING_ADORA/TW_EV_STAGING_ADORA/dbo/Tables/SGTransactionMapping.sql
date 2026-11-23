CREATE TABLE [dbo].[SGTransactionMapping] (
    [SGTranCode]    VARCHAR (50) NOT NULL,
    [AccountNumber] VARCHAR (50) NOT NULL,
    [TranCode]      VARCHAR (50) NOT NULL,
    [ReloadType]    INT          DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SGTransactiionMapping_AccountNumber_TranCode] PRIMARY KEY CLUSTERED ([AccountNumber] ASC, [TranCode] ASC),
    CONSTRAINT [FK_SGTransactionMapping_SGTransactiion_TranCode] FOREIGN KEY ([SGTranCode]) REFERENCES [dbo].[SGTransaction] ([TranCode])
);


GO
CREATE NONCLUSTERED INDEX [IDX_SGTransactionMapping_SGTranCode]
    ON [dbo].[SGTransactionMapping]([SGTranCode] ASC);

