CREATE TABLE [dbo].[TXCSLMSTemplateVersionMapping] (
    [SLMSTemplateVersionId] INT NOT NULL,
    [TXCTenantId]           INT NOT NULL,
    [ExternalId]            INT NOT NULL,
    CONSTRAINT [PK_TXCSLMSTemplateVersionMapping] PRIMARY KEY CLUSTERED ([SLMSTemplateVersionId] ASC)
);

