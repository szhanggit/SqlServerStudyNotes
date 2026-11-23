CREATE TABLE [dbo].[PublishedEvent] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Status]      TINYINT        NOT NULL,
    [EventType]   TINYINT        NOT NULL,
    [EventId]     VARCHAR (50)   NOT NULL,
    [Parameters]  NVARCHAR (MAX) NULL,
    [CreatedOn]   DATETIME       NOT NULL,
    [PublishedOn] DATETIME       NULL,
    [Comment]     NVARCHAR (MAX) NULL,
    [TryCount]    INT            CONSTRAINT [DF__Published__TryCo__481BA567] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_PublishedEvent_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

