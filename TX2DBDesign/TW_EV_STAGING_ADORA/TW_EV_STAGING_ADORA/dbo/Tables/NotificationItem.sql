CREATE TABLE [dbo].[NotificationItem] (
    [Id]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [Status]         TINYINT        NOT NULL,
    [ProviderType]   VARCHAR (50)   NOT NULL,
    [ProviderCode]   VARCHAR (50)   NOT NULL,
    [Parameters]     NVARCHAR (MAX) NULL,
    [CreatedOn]      DATETIME       NOT NULL,
    [LastNotifiedOn] DATETIME       NULL,
    [LastResponse]   NVARCHAR (MAX) NULL,
    [TryCount]       INT            NOT NULL,
    CONSTRAINT [PK_NotificationItem] PRIMARY KEY CLUSTERED ([Id] ASC)
);

