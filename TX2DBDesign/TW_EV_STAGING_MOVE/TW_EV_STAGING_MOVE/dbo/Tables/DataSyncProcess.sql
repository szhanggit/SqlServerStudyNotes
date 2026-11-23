CREATE TABLE [dbo].[DataSyncProcess] (
    [Id]           INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SessionId]    VARCHAR (50)   NULL,
    [Count]        INT            NULL,
    [ResponseCode] VARCHAR (10)   NULL,
    [Message]      VARCHAR (5000) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

