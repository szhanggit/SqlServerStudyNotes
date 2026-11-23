CREATE TABLE [dbo].[TaskTrack] (
    [Id]           BIGINT        IDENTITY (1, 1) NOT NULL,
    [TaskId]       BIGINT        NOT NULL,
    [TaskLocalId]  BIGINT        NOT NULL,
    [MessageType]  INT           NOT NULL,
    [AssemblyName] VARCHAR (100) NOT NULL,
    [FullTypeName] VARCHAR (100) NOT NULL,
    [Status]       INT           NOT NULL,
    [CountryName]  VARCHAR (100) NOT NULL,
    [CreatedOn]    DATETIME      NOT NULL,
    [TrackedTime]  DATETIME      NULL,
    CONSTRAINT [PK_TaskTrack] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

