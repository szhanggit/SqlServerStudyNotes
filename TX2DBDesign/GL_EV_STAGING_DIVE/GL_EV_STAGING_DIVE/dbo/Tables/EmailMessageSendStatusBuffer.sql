CREATE TABLE [dbo].[EmailMessageSendStatusBuffer] (
    [Id]                       BIGINT           IDENTITY (1, 1) NOT NULL,
    [EmailMessageSendStatusId] INT              NOT NULL,
    [SessionId]                UNIQUEIDENTIFIER NOT NULL,
    [MessageId]                NVARCHAR (100)   NOT NULL,
    [SendStatus]               INT              NOT NULL,
    [OriginalStatus]           NVARCHAR (50)    NOT NULL,
    [Description]              NVARCHAR (4000)  NULL,
    [CreatedTime]              DATETIME         NOT NULL,
    [Country]                  NVARCHAR (50)    NULL,
    [OriginalTime]             DATETIME         NULL,
    CONSTRAINT [PK_EmailMessageSendStatusBuffer] PRIMARY KEY CLUSTERED ([Id] ASC)
);

