CREATE TABLE [dbo].[BatchLog] (
    [Id]                BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProgramId]         INT            NULL,
    [BatchName]         NVARCHAR (100) NOT NULL,
    [ExecuteStartTime]  DATETIME       NOT NULL,
    [ExecuteEndTime]    DATETIME       NULL,
    [DataStartTime]     DATETIME       NULL,
    [DataEndTime]       DATETIME       DEFAULT ('0') NULL,
    [DataCount]         INT            DEFAULT ((0)) NOT NULL,
    [Status]            TINYINT        NOT NULL,
    [IsVerifiedSuccess] BIT            NULL,
    [DataEndTimeL]      BIGINT         NULL,
    CONSTRAINT [PK_BatchLog_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_BatchLog_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([Id])
);

