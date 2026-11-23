CREATE TABLE [dbo].[SLMSMessageArchiveTemp] (
    [SessionId]     VARCHAR (50) NOT NULL,
    [SLMSMessageId] BIGINT       NOT NULL,
    [TaskId]        BIGINT       NOT NULL,
    CONSTRAINT [PK_SLMSMessageArchiveTemp] PRIMARY KEY CLUSTERED ([SessionId] ASC, [SLMSMessageId] ASC) WITH (FILLFACTOR = 90)
);

