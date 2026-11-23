CREATE TABLE [dbo].[ContentTagValue] (
    [Id]                    INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ContentTagId]          INT            NOT NULL,
    [HtmlValue]             NVARCHAR (MAX) NULL,
    [TextValue]             NVARCHAR (MAX) NULL,
    [ApplyConditionId]      INT            NULL,
    [DraftTextValue]        NVARCHAR (MAX) NULL,
    [DraftHtmlValue]        NVARCHAR (MAX) NULL,
    [DraftApplyConditionId] INT            NULL,
    [IsDefault]             BIT            NOT NULL,
    [CreatedBy]             NVARCHAR (100) NOT NULL,
    [CreatedOn]             DATETIME       NOT NULL,
    [ApprovedBy]            NVARCHAR (100) NULL,
    [ApprovedOn]            DATETIME       NULL,
    CONSTRAINT [PK_ContentTagValue_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ContentTagValue_ApplyCondition_ApplyConditionId] FOREIGN KEY ([ApplyConditionId]) REFERENCES [dbo].[ApplyCondition] ([Id]),
    CONSTRAINT [FK_ContentTagValue_ApplyCondition_DraftApplyConditionId] FOREIGN KEY ([DraftApplyConditionId]) REFERENCES [dbo].[ApplyCondition] ([Id]),
    CONSTRAINT [FK_ContentTagValue_ContentTag_ContentTagId] FOREIGN KEY ([ContentTagId]) REFERENCES [dbo].[ContentTag] ([Id])
);

