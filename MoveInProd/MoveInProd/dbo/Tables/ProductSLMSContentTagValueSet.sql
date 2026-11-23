CREATE TABLE [dbo].[ProductSLMSContentTagValueSet] (
    [Id]                            INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ContentTagId]                  INT            NOT NULL,
    [ProductSLMSTemplateTagValueId] INT            NOT NULL,
    [Value]                         NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_PRODUCTSLMSCONTENTTAGVALUES] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductSLMSContentTagValueSet_ContentTag_ContentTagId] FOREIGN KEY ([ContentTagId]) REFERENCES [dbo].[ContentTag] ([Id]),
    CONSTRAINT [FK_ProductSLMSContentTagValueSet_ProductSLMSTemplateTagValue_ProductSLMSTemplateTagValueId] FOREIGN KEY ([ProductSLMSTemplateTagValueId]) REFERENCES [dbo].[ProductSLMSTemplateTagValue] ([Id])
);

