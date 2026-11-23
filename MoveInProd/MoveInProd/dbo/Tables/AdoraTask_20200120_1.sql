CREATE TABLE [dbo].[AdoraTask_20200120] (
    [Id]               BIGINT       IDENTITY (1, 1) NOT NULL,
    [OrderId]          INT          NOT NULL,
    [StartOrderSN]     INT          NOT NULL,
    [EndOrderSN]       INT          NOT NULL,
    [Status]           TINYINT      NOT NULL,
    [CreationTime]     DATETIME     NOT NULL,
    [ExecuteStartTime] DATETIME     NULL,
    [ExecuteEndTime]   DATETIME     NULL,
    [SessionId]        VARCHAR (50) NULL,
    [PartialPublish]   BIT          NULL
);

