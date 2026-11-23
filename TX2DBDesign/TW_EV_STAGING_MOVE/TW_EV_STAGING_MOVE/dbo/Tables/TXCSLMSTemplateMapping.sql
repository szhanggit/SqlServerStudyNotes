CREATE TABLE [dbo].[TXCSLMSTemplateMapping] (
    [SLMSTemplateId] INT NOT NULL,
    [TXCTenantId]    INT NOT NULL,
    [ExternalId]     INT NOT NULL,
    CONSTRAINT [PK_TXCSLMSTemplateMapping] PRIMARY KEY CLUSTERED ([SLMSTemplateId] ASC)
);

