CREATE TABLE [dbo].[ProductEmailContentTagValueSet] (
    [Id]                             INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ContentTagId]                   INT            NOT NULL,
    [ProductEmailTemplateTagValueId] INT            NOT NULL,
    [Value]                          NVARCHAR (MAX) NULL,
    [TextValue]                      NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_PRODUCTEMAILCONTENTTAGVALUE] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ProductEmailContentTagValueSet_ContentTag_ContentTagId] FOREIGN KEY ([ContentTagId]) REFERENCES [dbo].[ContentTag] ([Id]),
    CONSTRAINT [FK_ProductEmailContentTagValueSet_ProductEmailTemplateTagValue_ProductEmailTemplateTagValueId] FOREIGN KEY ([ProductEmailTemplateTagValueId]) REFERENCES [dbo].[ProductEmailTemplateTagValue] ([Id])
);

