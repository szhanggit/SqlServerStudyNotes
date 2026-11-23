CREATE TABLE [dbo].[AppLog] (
    [Id]             BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Application]    NVARCHAR (50)  NOT NULL,
    [ActionCategory] NVARCHAR (250) NULL,
    [ActionType]     NVARCHAR (250) NULL,
    [Operator]       NVARCHAR (250) NULL,
    [LoggedOn]       DATETIME       NOT NULL,
    [ThreadId]       INT            NOT NULL,
    [Level]          VARCHAR (50)   NOT NULL,
    [MachineName]    NVARCHAR (250) NULL,
    [Logger]         NVARCHAR (250) NULL,
    [Message]        NVARCHAR (MAX) NULL,
    [Keyword1]       NVARCHAR (250) NULL,
    [Keyword2]       NVARCHAR (250) NULL,
    [Keyword3]       NVARCHAR (250) NULL,
    [KeywordMapping] NVARCHAR (250) NULL,
    CONSTRAINT [PK_AppLog_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

