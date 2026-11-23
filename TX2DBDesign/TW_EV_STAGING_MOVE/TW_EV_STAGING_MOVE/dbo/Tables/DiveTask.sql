CREATE TABLE [dbo].[DiveTask] (
    [Id]               BIGINT       IDENTITY (1, 1) NOT NULL,
    [OrderId]          INT          NOT NULL,
    [OrderLineId]      INT          NOT NULL,
    [StartOrderLineSN] INT          NOT NULL,
    [EndOrderLineSN]   INT          NOT NULL,
    [Status]           TINYINT      NOT NULL,
    [CreationTime]     DATETIME     NOT NULL,
    [ExecuteStartTime] DATETIME     NULL,
    [ExecuteEndTime]   DATETIME     NULL,
    [SessionId]        VARCHAR (50) NULL,
    CONSTRAINT [PK_DiveTask_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

