CREATE TABLE [dbo].[NotificationTargetSender] (
    [Id]                  INT           IDENTITY (1, 1) NOT NULL,
    [ProgramCode]         VARCHAR (20)  NOT NULL,
    [NotificationType]    TINYINT       NOT NULL,
    [TargetType]          TINYINT       NOT NULL,
    [NotificationChannel] TINYINT       NOT NULL,
    [TargetAddress]       VARCHAR (200) NULL,
    [SenderName]          VARCHAR (50)  NOT NULL,
    [Assembly]            VARCHAR (200) NULL,
    [ReflectionType]      VARCHAR (200) NULL,
    [RemoteAddress]       VARCHAR (200) NOT NULL,
    [ClientCode]          VARCHAR (50)  NULL,
    [SecurityKey]         VARCHAR (50)  NULL,
    [ChannelId]           VARCHAR (200) NULL,
    [ChannelSecret]       VARCHAR (200) NULL,
    [BearerToken]         VARCHAR (500) NULL,
    CONSTRAINT [PK_NotificationTargetSender_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

