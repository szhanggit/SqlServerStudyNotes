CREATE TABLE [dbo].[SLMSMessageTemplateArchive] (
    [Id]      BIGINT         NOT NULL,
    [Content] NVARCHAR (500) NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [IX_SLMSMessageTemplateArchive]
    ON [dbo].[SLMSMessageTemplateArchive]([Id] ASC) WITH (IGNORE_DUP_KEY = ON);

