CREATE TABLE [dbo].[TXCProductMapping] (
    [ProductId]   INT NOT NULL,
    [TXCTenantId] INT NOT NULL,
    [ExternalId]  INT NULL,
    CONSTRAINT [PK_TXCProductMapping] PRIMARY KEY CLUSTERED ([ProductId] ASC, [TXCTenantId] ASC) WITH (FILLFACTOR = 90)
);

