CREATE TABLE [dbo].[SLMSMessageSendStatus] (
    [Id]             BIGINT          IDENTITY (1, 1) NOT NULL,
    [MessageId]      NVARCHAR (100)  NOT NULL,
    [SendStatus]     INT             NOT NULL,
    [OriginalStatus] NVARCHAR (50)   NOT NULL,
    [Country]        NVARCHAR (50)   NULL,
    [Description]    NVARCHAR (4000) NULL,
    [CreatedTime]    DATETIME        NOT NULL,
    [OriginalTime]   DATETIME        NULL,
    CONSTRAINT [PK_SLMSMessageSendStatus] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

