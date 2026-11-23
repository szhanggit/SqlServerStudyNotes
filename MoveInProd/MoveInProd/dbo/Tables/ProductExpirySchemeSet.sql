CREATE TABLE [dbo].[ProductExpirySchemeSet] (
    [Id]                    INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProductExpirySchemeId] INT NULL,
    [ExpirationPolicyId]    INT NOT NULL,
    CONSTRAINT [PK_PRODUCTEXPIRYSCHEMESET] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductExpirySchemeSet_ExpirationPolicy_ExpirationPolicyId] FOREIGN KEY ([ExpirationPolicyId]) REFERENCES [dbo].[ExpirationPolicy] ([Id]),
    CONSTRAINT [FK_ProductExpirySchemeSet_ProductExpiryScheme_ProductExpirySchemeId] FOREIGN KEY ([ProductExpirySchemeId]) REFERENCES [dbo].[ProductExpiryScheme] ([Id])
);

