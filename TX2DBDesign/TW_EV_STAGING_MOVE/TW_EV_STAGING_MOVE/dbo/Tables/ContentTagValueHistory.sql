CREATE TABLE [dbo].[ContentTagValueHistory] (
    [Id]                INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ContentTagValueId] INT            NULL,
    [HtmlValue]         NVARCHAR (MAX) NULL,
    [TextValue]         NVARCHAR (MAX) NULL,
    [CreatedBy]         NVARCHAR (100) NOT NULL,
    [CreatedOn]         DATETIME       NOT NULL,
    [ApprovedBy]        NVARCHAR (100) NULL,
    [ApprovedOn]        DATETIME       NULL,
    CONSTRAINT [PK_ContentTagValueHistory_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ContentTagValueHistory_ContentTagValue_ContentTagValueId] FOREIGN KEY ([ContentTagValueId]) REFERENCES [dbo].[ContentTagValue] ([Id])
);

