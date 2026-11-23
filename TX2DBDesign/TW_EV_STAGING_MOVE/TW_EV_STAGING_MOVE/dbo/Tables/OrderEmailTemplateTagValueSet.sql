CREATE TABLE [dbo].[OrderEmailTemplateTagValueSet] (
    [Id]                           INT            IDENTITY (1, 1) NOT NULL,
    [ContentTagId]                 INT            NOT NULL,
    [OrderEmailTemplateTagValueId] INT            NOT NULL,
    [Value]                        NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_OrderEmailTemplateTagValueSet] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_OrderEmailTemplateTagValueSet_ContentTag_ContentTagId] FOREIGN KEY ([ContentTagId]) REFERENCES [dbo].[ContentTag] ([Id]),
    CONSTRAINT [FK_OrderEmailTemplateTagValueSet_OrderEmailTemplateTagValue_OrderEmailTemplateTagValueId] FOREIGN KEY ([OrderEmailTemplateTagValueId]) REFERENCES [dbo].[OrderEmailTemplateTagValue] ([Id]),
    CONSTRAINT [UK_OrderEmailTemplateTagValueSet] UNIQUE NONCLUSTERED ([ContentTagId] ASC, [OrderEmailTemplateTagValueId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_OrderEmailTemplateTagValueSet_OrderEmailTemplateTagValueId]
    ON [dbo].[OrderEmailTemplateTagValueSet]([OrderEmailTemplateTagValueId] ASC);

