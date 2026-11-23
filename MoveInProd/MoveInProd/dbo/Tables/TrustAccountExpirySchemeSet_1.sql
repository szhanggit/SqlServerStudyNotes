CREATE TABLE [dbo].[TrustAccountExpirySchemeSet] (
    [Id]                         INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TrustAccountExpirySchemeId] INT NOT NULL,
    [TrustExpiryPolicyId]        INT NOT NULL,
    CONSTRAINT [PK_TrustAccountExpirySchemeSet] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TrustAccountExpirySchemeSet_TrustAccountExpiryScheme_TrustAccountExpirySchemeId] FOREIGN KEY ([TrustAccountExpirySchemeId]) REFERENCES [dbo].[TrustAccountExpiryScheme] ([Id]),
    CONSTRAINT [FK_TrustAccountExpirySchemeSet_TrustExpiryPolicy_TrustExpiryPolicyId] FOREIGN KEY ([TrustExpiryPolicyId]) REFERENCES [dbo].[TrustExpiryPolicy] ([Id]),
    CONSTRAINT [UK_TrustAccountExpirySchemeSet] UNIQUE NONCLUSTERED ([TrustAccountExpirySchemeId] ASC, [TrustExpiryPolicyId] ASC)
);

