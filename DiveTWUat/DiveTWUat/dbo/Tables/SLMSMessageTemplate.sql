CREATE TABLE [dbo].[SLMSMessageTemplate] (
    [Id]      BIGINT         IDENTITY (1, 1) NOT NULL,
    [Content] NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK_MessageSLMSTemplate] PRIMARY KEY CLUSTERED ([Id] ASC)
);

