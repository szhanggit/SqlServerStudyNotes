CREATE TABLE [dbo].[TXCBrandMapping] (
    [BrandId]     INT NOT NULL,
    [TXCTenantId] INT NOT NULL,
    [ExternalId]  INT NULL,
    CONSTRAINT [PK_TXCBrandMapping] PRIMARY KEY CLUSTERED ([BrandId] ASC, [TXCTenantId] ASC)
);

