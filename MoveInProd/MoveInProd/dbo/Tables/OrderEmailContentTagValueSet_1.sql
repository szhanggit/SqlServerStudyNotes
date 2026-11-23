CREATE TABLE [dbo].[OrderEmailContentTagValueSet] (
    [Id]           INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ContentTagId] INT            NOT NULL,
    [OrderLineId]  INT            NOT NULL,
    [Value]        NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_ORDEREMAILCONTENTTAGVALUESE] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_OrderEmailContentTagValueSet_ContentTag_ContentTagId] FOREIGN KEY ([ContentTagId]) REFERENCES [dbo].[ContentTag] ([Id]),
    CONSTRAINT [FK_OrderEmailContentTagValueSet_OrderLine_OrderLineId] FOREIGN KEY ([OrderLineId]) REFERENCES [dbo].[OrderLine] ([Id])
);

