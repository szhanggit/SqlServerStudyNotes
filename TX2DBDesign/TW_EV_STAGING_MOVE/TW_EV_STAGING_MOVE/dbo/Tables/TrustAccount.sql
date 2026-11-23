CREATE TABLE [dbo].[TrustAccount] (
    [Id]               INT             IDENTITY (1, 1) NOT NULL,
    [TrustBankCode]    VARCHAR (20)    NOT NULL,
    [TrustAccountCode] VARCHAR (30)    NOT NULL,
    [Name]             NVARCHAR (50)   NOT NULL,
    [Bank]             NVARCHAR (50)   NOT NULL,
    [Fee]              NUMERIC (20, 6) NOT NULL,
    [IsDefault]        BIT             NULL,
    [ExpirySchemeId]   INT             NULL,
    CONSTRAINT [PK_TrustAccount_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TrustAccount_TrustAccountExpiryScheme_ExpirySchemeId] FOREIGN KEY ([ExpirySchemeId]) REFERENCES [dbo].[TrustAccountExpiryScheme] ([Id])
);

