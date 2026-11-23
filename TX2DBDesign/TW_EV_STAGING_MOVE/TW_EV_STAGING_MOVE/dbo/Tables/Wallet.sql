CREATE TABLE [dbo].[Wallet] (
    [Id]            BIGINT           IDENTITY (1, 1) NOT NULL,
    [WalletAlias]   VARCHAR (20)     COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
    [WalletCode]    VARCHAR (20)     NOT NULL,
    [GUID]          UNIQUEIDENTIFIER NOT NULL,
    [OrderId]       INT              NOT NULL,
    [WalletGroupBy] INT              NOT NULL,
    [CreatedOn]     DATETIME         NOT NULL,
    CONSTRAINT [PK_Wallet] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_Wallet_WalletAlias]
    ON [dbo].[Wallet]([WalletAlias] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_Wallet_GUID]
    ON [dbo].[Wallet]([GUID] ASC);

