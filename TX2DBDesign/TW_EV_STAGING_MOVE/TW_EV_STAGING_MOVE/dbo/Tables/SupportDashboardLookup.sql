CREATE TABLE [dbo].[SupportDashboardLookup] (
    [Id]             INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]           VARCHAR (100) NOT NULL,
    [DBKey]          VARCHAR (50)  NOT NULL,
    [StoreProcedure] VARCHAR (100) NULL,
    [Result]         BIGINT        NULL,
    [Mark]           INT           NULL,
    [MarkOperation]  INT           NULL,
    [NotifyChannel]  INT           NULL,
    [Level]          INT           NULL,
    [ScanningSpeed]  INT           NULL,
    [Message]        INT           NULL,
    [IsActive]       INT           NULL,
    [LastUpdateTime] DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

