CREATE TABLE [dbo].[SLMSTemplateContentTag] (
    [Id]           INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TemplateId]   INT NOT NULL,
    [ContentTagId] INT NOT NULL,
    CONSTRAINT [PK_SLMSTemplateContentTag] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_SLMSTemplateContentTag_ContentTag_ContentTagId] FOREIGN KEY ([ContentTagId]) REFERENCES [dbo].[ContentTag] ([Id]),
    CONSTRAINT [FK_SLMSTemplateContentTag_SLMSTemplate_TemplateId] FOREIGN KEY ([TemplateId]) REFERENCES [dbo].[SLMSTemplateVersion] ([Id]),
    CONSTRAINT [UK_SLMSTemplateContentTag_Id_Tag] UNIQUE NONCLUSTERED ([TemplateId] ASC, [ContentTagId] ASC)
);

