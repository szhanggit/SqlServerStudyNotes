CREATE TABLE [dbo].[SyncTranProcess] (
    [Id]            INT          IDENTITY (1, 1) NOT NULL,
    [OlapStartId]   BIGINT       NOT NULL,
    [OlapEndId]     BIGINT       NOT NULL,
    [LastMaxTranId] BIGINT       NOT NULL,
    [ThisMaxTranId] BIGINT       NOT NULL,
    [DataCount]     INT          NOT NULL,
    [Status]        INT          NOT NULL,
    [CreateTime]    DATETIME     NOT NULL,
    [SessionId]     VARCHAR (40) NOT NULL,
    CONSTRAINT [PK_SyncTranProcess_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

