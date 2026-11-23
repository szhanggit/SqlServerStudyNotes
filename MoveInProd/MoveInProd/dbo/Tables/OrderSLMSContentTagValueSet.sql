CREATE TABLE [dbo].[OrderSLMSContentTagValueSet] (
    [Id]           INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ContentTagId] INT            NOT NULL,
    [OrderLineId]  INT            NOT NULL,
    [Value]        NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_ORDERSLMSCONTENTTAGVALUESET] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_OrderSLMSContentTagValueSet_ContentTag_ContentTagId] FOREIGN KEY ([ContentTagId]) REFERENCES [dbo].[ContentTag] ([Id]),
    CONSTRAINT [FK_OrderSLMSContentTagValueSet_OrderLine_OrderLineId] FOREIGN KEY ([OrderLineId]) REFERENCES [dbo].[OrderLine] ([Id])
);

