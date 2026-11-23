CREATE TABLE [dbo].[AccountNotificationSubscription] (
    [Id]                  BIGINT         IDENTITY (1, 1) NOT NULL,
    [AccountNumber]       VARCHAR (50)   NOT NULL,
    [ProgramId]           INT            NOT NULL,
    [SenderCode]          VARCHAR (50)   NOT NULL,
    [Status]              TINYINT        NOT NULL,
    [SubscriberType]      VARCHAR (50)   NULL,
    [NotificationChannel] VARCHAR (50)   NULL,
    [SubscriberAddress]   VARCHAR (200)  NULL,
    [SubscribeOn]         DATETIME       NOT NULL,
    [UnsubscribeOn]       DATETIME       NULL,
    [Comment]             NVARCHAR (255) NULL,
    CONSTRAINT [PK_AccountNotificationSubscription_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IDX_AccountNotificationSubscription_AccountNumber_ProgramId_SenderCode]
    ON [dbo].[AccountNotificationSubscription]([AccountNumber] ASC, [ProgramId] ASC, [SenderCode] ASC, [Status] ASC) WITH (FILLFACTOR = 90);

