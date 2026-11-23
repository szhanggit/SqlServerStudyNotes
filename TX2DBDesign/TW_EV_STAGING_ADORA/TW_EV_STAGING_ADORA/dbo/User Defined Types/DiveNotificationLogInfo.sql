CREATE TYPE [dbo].[DiveNotificationLogInfo] AS TABLE (
    [AccountNumber]      VARCHAR (100)  NULL,
    [ProgramCode]        VARCHAR (50)   NULL,
    [TranCode]           VARCHAR (100)  NULL,
    [NotificationItemId] INT            NULL,
    [TranStatus]         INT            NULL,
    [CreatedOn]          DATETIME       NULL,
    [NotifiedOn]         DATETIME       NULL,
    [Response]           NVARCHAR (MAX) NULL,
    [ActionDate]         DATETIME       NULL);

