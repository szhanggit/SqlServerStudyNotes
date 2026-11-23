CREATE TABLE [dbo].[TXCEmailTemplateMapping] (
    [EmailTemplateId] INT NOT NULL,
    [TXCTenantId]     INT NOT NULL,
    [ExternalId]      INT NOT NULL,
    CONSTRAINT [PK_TXCEmailTemplateMapping] PRIMARY KEY CLUSTERED ([EmailTemplateId] ASC)
);

