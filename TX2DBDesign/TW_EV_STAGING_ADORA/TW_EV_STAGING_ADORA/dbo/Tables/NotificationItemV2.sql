CREATE TABLE [dbo].[NotificationItemV2] (
    [Id]                BIGINT         IDENTITY (1, 1) NOT NULL,
    [ProviderType]      VARCHAR (50)   NOT NULL,
    [ProviderCode]      VARCHAR (50)   NOT NULL,
    [Parameters]        NVARCHAR (MAX) NULL,
    [TranLocalDateTime] DATETIME       NOT NULL,
    [Status]            TINYINT        NOT NULL,
    [LastResponse]      NVARCHAR (MAX) NULL,
    [TryCount]          INT            NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_NotificationItemV2_TranLocalDateTime]
    ON [dbo].[NotificationItemV2]([TranLocalDateTime] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_NotificationItemV2_Id]
    ON [dbo].[NotificationItemV2]([Id] ASC);

