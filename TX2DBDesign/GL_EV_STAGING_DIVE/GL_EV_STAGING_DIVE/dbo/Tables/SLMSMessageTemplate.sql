CREATE TABLE [dbo].[SLMSMessageTemplate] (
    [Id]      BIGINT         IDENTITY (1, 1) NOT NULL,
    [Content] NVARCHAR (900) NOT NULL,
    CONSTRAINT [PK_MessageSLMSTemplate] PRIMARY KEY CLUSTERED ([Id] ASC)
);

