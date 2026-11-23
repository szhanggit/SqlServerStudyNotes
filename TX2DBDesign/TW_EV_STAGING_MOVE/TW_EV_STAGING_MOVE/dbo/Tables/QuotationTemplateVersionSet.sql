CREATE TABLE [dbo].[QuotationTemplateVersionSet] (
    [Id]                INT IDENTITY (1, 1) NOT NULL,
    [ClientQuotationId] INT NOT NULL,
    [LanguageId]        INT NOT NULL,
    [TemplateId]        INT NOT NULL,
    [TemplateVersionId] INT NOT NULL,
    [IsEmail]           BIT NOT NULL,
    [TemplateType]      INT DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_QuotationTemplateVersionSet_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Index_QuotationTemplateVersionSet_ClientQuotationId]
    ON [dbo].[QuotationTemplateVersionSet]([ClientQuotationId] ASC);

