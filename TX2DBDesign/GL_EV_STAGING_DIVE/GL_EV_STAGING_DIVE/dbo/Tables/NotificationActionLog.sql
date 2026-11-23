CREATE TABLE [dbo].[NotificationActionLog] (
    [Id]                   BIGINT         IDENTITY (1, 1) NOT NULL,
    [NotificationId]       BIGINT         NOT NULL,
    [NotificationTargetId] BIGINT         NOT NULL,
    [NotificationLocalId]  VARCHAR (50)   NOT NULL,
    [ActionType]           TINYINT        NOT NULL,
    [CreatedOn]            DATETIME       NOT NULL,
    [ResponseCode]         VARCHAR (50)   NULL,
    [ResponsedOn]          DATETIME       NULL,
    [RequestMessage]       NVARCHAR (MAX) NULL,
    [ResponseMessage]      NVARCHAR (MAX) NULL,
    [Operator]             NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_NotificationActionLog_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

