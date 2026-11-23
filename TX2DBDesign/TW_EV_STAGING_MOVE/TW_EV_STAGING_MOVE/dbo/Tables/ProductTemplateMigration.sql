CREATE TABLE [dbo].[ProductTemplateMigration] (
    [TXCProductTemplateId]          INT IDENTITY (1, 1) NOT NULL,
    [ProductId]                     INT NOT NULL,
    [ProductEmailTemplateVersionId] INT NULL,
    [ProductSLMSTemplateVersionId]  INT NULL,
    [TXCProductTemplateVersionId1]  INT NULL,
    [TXCProductTemplateVersionId2]  INT NULL,
    CONSTRAINT [PK_ProductTemplateMigration] PRIMARY KEY CLUSTERED ([TXCProductTemplateId] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [UK_ProductTemplateMigration] UNIQUE NONCLUSTERED ([ProductId] ASC, [ProductEmailTemplateVersionId] ASC, [ProductSLMSTemplateVersionId] ASC) WITH (FILLFACTOR = 90)
);

