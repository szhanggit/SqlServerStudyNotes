CREATE TABLE [dbo].[OrderSLMSTemplateTagValueSet] (
    [Id]                          INT            IDENTITY (1, 1) NOT NULL,
    [ContentTagId]                INT            NOT NULL,
    [OrderSLMSTemplateTagValueId] INT            NOT NULL,
    [Value]                       NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_OrderSLMSTemplateTagValueSet] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_OrderSLMSTemplateTagValueSet_ContentTag_ContentTagId] FOREIGN KEY ([ContentTagId]) REFERENCES [dbo].[ContentTag] ([Id]),
    CONSTRAINT [FK_OrderSLMSTemplateTagValueSet_OrderSLMSTemplateTagValue_OrderSLMSTemplateTagValueId] FOREIGN KEY ([OrderSLMSTemplateTagValueId]) REFERENCES [dbo].[OrderSLMSTemplateTagValue] ([Id]),
    CONSTRAINT [UK_OrderSLMSTemplateTagValueSet] UNIQUE NONCLUSTERED ([ContentTagId] ASC, [OrderSLMSTemplateTagValueId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_OrderSLMSTemplateTagValueSet_OrderSLMSTemplateTagValueId]
    ON [dbo].[OrderSLMSTemplateTagValueSet]([OrderSLMSTemplateTagValueId] ASC);

