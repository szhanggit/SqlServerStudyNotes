CREATE TABLE [dbo].[TXCProductVersionMapping] (
    [ProductVersionId] INT NOT NULL,
    [TXCTenantId]      INT NOT NULL,
    [ExternalId]       INT NULL,
    CONSTRAINT [PK_TXCProductVersionMapping] PRIMARY KEY CLUSTERED ([ProductVersionId] ASC, [TXCTenantId] ASC) WITH (FILLFACTOR = 90)
);

