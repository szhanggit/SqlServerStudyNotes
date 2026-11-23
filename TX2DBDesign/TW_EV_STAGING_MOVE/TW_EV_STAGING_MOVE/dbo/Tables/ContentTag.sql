CREATE TABLE [dbo].[ContentTag] (
    [Id]                   INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TagName]              VARCHAR (50)    NOT NULL,
    [TagDisplayNameId]     INT             NOT NULL,
    [TagCategory]          TINYINT         NOT NULL,
    [TagType]              TINYINT         NOT NULL,
    [DefaultValue]         NVARCHAR (4000) NULL,
    [CanAppliedToEmail]    BIT             NOT NULL,
    [CanAppliedToSLMS]     BIT             NOT NULL,
    [CanAppliedToMMS]      BIT             NOT NULL,
    [ReflectionType]       VARCHAR (100)   NULL,
    [Description]          NVARCHAR (500)  NULL,
    [CanBeModifiedInOrder] BIT             NOT NULL,
    [ScopeLevel]           TINYINT         NOT NULL,
    CONSTRAINT [PK_CONTENTTAG] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ContentTag_Dictionary_TagDisplayNameId] FOREIGN KEY ([TagDisplayNameId]) REFERENCES [dbo].[Dictionary] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'SystemTagUsedOnly = 1,
   SystemTagCanModify = 2,
   OthersTag=3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ContentTag', @level2type = N'COLUMN', @level2name = N'TagCategory';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--Text
   2--Image', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ContentTag', @level2type = N'COLUMN', @level2name = N'TagType';

