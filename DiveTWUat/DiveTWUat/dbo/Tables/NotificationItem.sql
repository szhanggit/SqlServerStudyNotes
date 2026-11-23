CREATE TABLE [dbo].[NotificationItem] (
    [Id]           BIGINT         IDENTITY (1, 1) NOT NULL,
    [Status]       TINYINT        NOT NULL,
    [ProviderType] VARCHAR (50)   NOT NULL,
    [ProviderCode] VARCHAR (50)   NOT NULL,
    [Parameters]   NVARCHAR (MAX) NOT NULL,
    [CreatedOn]    DATETIME       NOT NULL,
    [NotifiedOn]   DATETIME       NULL,
    [Response]     NVARCHAR (MAX) NULL,
    [TryCount]     INT            DEFAULT ((0)) NOT NULL,
    [SyncToken]    VARCHAR (80)   NULL
);

