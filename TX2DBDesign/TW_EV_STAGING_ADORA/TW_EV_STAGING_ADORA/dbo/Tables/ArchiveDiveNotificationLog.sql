CREATE TABLE [dbo].[ArchiveDiveNotificationLog] (
    [Id]                    INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [DiveNotificationLogId] INT            NOT NULL,
    [AccountNumber]         VARCHAR (50)   NULL,
    [ProgramCode]           VARCHAR (20)   NULL,
    [TranCode]              VARCHAR (50)   NULL,
    [TranType]              SMALLINT       NULL,
    [TranLocalDateTime]     DATETIME       NULL,
    [TranLocalDate]         INT            NULL,
    [OrderNum]              INT            NULL,
    [OrderNumOnDive]        INT            NULL,
    [NotificationItemId]    INT            NULL,
    [DiveTranStatus]        INT            NULL,
    [NotifiedOn]            DATETIME       NULL,
    [CreatedOn]             DATETIME       NULL,
    [Response]              NVARCHAR (MAX) NULL,
    [Fixed]                 INT            NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

