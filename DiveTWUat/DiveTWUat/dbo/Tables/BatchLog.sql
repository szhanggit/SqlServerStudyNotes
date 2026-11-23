CREATE TABLE [dbo].[BatchLog] (
    [Id]                BIGINT         IDENTITY (1, 1) NOT NULL,
    [ProgramCode]       VARCHAR (20)   NULL,
    [BatchName]         NVARCHAR (100) NOT NULL,
    [ExecuteStartTime]  DATETIME       NOT NULL,
    [ExecuteEndTime]    DATETIME       NULL,
    [DataStartTime]     DATETIME       NULL,
    [DataEndTime]       DATETIME       NULL,
    [DataCount]         INT            CONSTRAINT [DF__BatchLog__DataCo__15502E78] DEFAULT ((0)) NOT NULL,
    [Status]            TINYINT        NOT NULL,
    [IsVerifiedSuccess] BIT            NULL,
    [DataEndTimeL]      BIGINT         NULL,
    [ServerCode]        VARCHAR (50)   NULL,
    CONSTRAINT [PK_BatchLog_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

