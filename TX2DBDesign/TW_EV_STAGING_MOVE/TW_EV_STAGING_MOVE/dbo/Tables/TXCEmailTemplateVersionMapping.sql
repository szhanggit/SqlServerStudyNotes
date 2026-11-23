CREATE TABLE [dbo].[TXCEmailTemplateVersionMapping] (
    [EmailTemplateVersionId] INT NOT NULL,
    [TXCTenantId]            INT NOT NULL,
    [ExternalId]             INT NOT NULL,
    CONSTRAINT [PK_TXCEmailTemplateVersionMapping] PRIMARY KEY CLUSTERED ([EmailTemplateVersionId] ASC)
);

