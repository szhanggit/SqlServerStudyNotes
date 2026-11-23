CREATE TABLE [dbo].[AccountDeletionBuffer] (
    [Id]            BIGINT        IDENTITY (1, 1) NOT NULL,
    [ProgramId]     INT           NOT NULL,
    [AccountNumber] VARCHAR (100) NOT NULL,
    [SessionId]     INT           NULL,
    [TaskId]        VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

