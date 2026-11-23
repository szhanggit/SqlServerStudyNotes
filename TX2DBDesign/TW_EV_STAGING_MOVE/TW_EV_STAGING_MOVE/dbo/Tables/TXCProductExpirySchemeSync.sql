CREATE TABLE [dbo].[TXCProductExpirySchemeSync] (
    [RunId]                    VARCHAR (50) NOT NULL,
    [TXCProductExpirySchemeId] INT          NULL,
    [ExpirationPolicyId]       INT          NULL
);


GO
CREATE CLUSTERED INDEX [IX_TXCProductExpirySchemeSync]
    ON [dbo].[TXCProductExpirySchemeSync]([RunId] ASC, [TXCProductExpirySchemeId] ASC) WITH (FILLFACTOR = 90);

