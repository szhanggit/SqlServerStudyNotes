CREATE TABLE [dbo].[NotificationTarget] (
    [Id]                  BIGINT         IDENTITY (1, 1) NOT NULL,
    [NotificationId]      BIGINT         NOT NULL,
    [TargetType]          TINYINT        NOT NULL,
    [NotificationChannel] TINYINT        NOT NULL,
    [TargetAddress]       VARCHAR (200)  NOT NULL,
    [Status]              TINYINT        NOT NULL,
    [NotifiedOn]          DATETIME       NULL,
    [Response]            NVARCHAR (MAX) NULL,
    [TryCount]            INT            DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_NotificationTarget_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_NotificationTarget_Notification_NotificationId] FOREIGN KEY ([NotificationId]) REFERENCES [dbo].[Notification] ([Id])
);

