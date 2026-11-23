CREATE TABLE [dbo].[Notification] (
    [Id]               BIGINT         IDENTITY (1, 1) NOT NULL,
    [ProgramCode]      VARCHAR (20)   NOT NULL,
    [NotificationType] TINYINT        NOT NULL,
    [RequestId]        VARCHAR (50)   NOT NULL,
    [Status]           TINYINT        NOT NULL,
    [Parameters]       NVARCHAR (MAX) NOT NULL,
    [CreatedOn]        DATETIME       NOT NULL,
    [GeneratedOn]      DATETIME       NULL,
    CONSTRAINT [PK_Notification_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_Notification_Request] UNIQUE NONCLUSTERED ([ProgramCode] ASC, [NotificationType] ASC, [RequestId] ASC)
);

