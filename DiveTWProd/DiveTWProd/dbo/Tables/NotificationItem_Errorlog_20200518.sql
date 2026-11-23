CREATE TABLE [dbo].[NotificationItem_Errorlog_20200518] (
    [Id]           BIGINT         IDENTITY (1, 1) NOT NULL,
    [Status]       TINYINT        NOT NULL,
    [ProviderType] VARCHAR (50)   NOT NULL,
    [ProviderCode] VARCHAR (50)   NOT NULL,
    [Parameters]   NVARCHAR (MAX) NOT NULL,
    [CreatedOn]    DATETIME       NOT NULL,
    [NotifiedOn]   DATETIME       NULL,
    [Response]     NVARCHAR (MAX) NULL,
    [TryCount]     INT            NOT NULL,
    [SyncToken]    VARCHAR (80)   NULL
);

