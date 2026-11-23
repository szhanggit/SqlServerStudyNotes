CREATE TABLE [dbo].[TaskArchive] (
    [Id]                BIGINT         NOT NULL,
    [ConsumerId]        INT            NOT NULL,
    [ServiceProviderId] INT            NOT NULL,
    [TaskPriority]      INT            NOT NULL,
    [TaskStatus]        INT            NOT NULL,
    [MessageType]       INT            NOT NULL,
    [EmailTemplateId]   BIGINT         NULL,
    [SLMSTemplateId]    BIGINT         NULL,
    [MMSTemplateId]     BIGINT         NULL,
    [TaskLocalId]       BIGINT         NOT NULL,
    [ScheduledDate]     NVARCHAR (8)   NOT NULL,
    [ScheduledTime]     NVARCHAR (6)   NOT NULL,
    [ScheduledDateTime] DATETIME       NOT NULL,
    [TimezoneOffset]    VARCHAR (6)    NULL,
    [CreatedOn]         DATETIME       NOT NULL,
    [ProcessedOn]       DATETIME       NULL,
    [MessageNumber]     INT            NOT NULL,
    [TriedCount]        INT            DEFAULT ((0)) NOT NULL,
    [Comment]           NVARCHAR (500) NULL,
    [IsBulk]            BIT            DEFAULT ((0)) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [IX_TaskArchive]
    ON [dbo].[TaskArchive]([Id] ASC) WITH (IGNORE_DUP_KEY = ON);

