CREATE TABLE [dbo].[QuotationContentTagValueSet] (
    [Id]                            INT            IDENTITY (1, 1) NOT NULL,
    [QuotationTemplateVersionSetId] INT            NOT NULL,
    [ContentTagId]                  INT            NOT NULL,
    [Value]                         NVARCHAR (MAX) NULL,
    [TextValue]                     NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_QuotationContentTagValueSet_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Index_QuotationContentTagValueSet_QuotationTemplateVersionSetId]
    ON [dbo].[QuotationContentTagValueSet]([QuotationTemplateVersionSetId] ASC);

