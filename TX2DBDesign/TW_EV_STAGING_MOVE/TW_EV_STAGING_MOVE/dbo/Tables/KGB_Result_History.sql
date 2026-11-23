CREATE TABLE [dbo].[KGB_Result_History] (
    [Id]         INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AlertId]    INT           NOT NULL,
    [AlertName]  VARCHAR (100) NOT NULL,
    [Env]        VARCHAR (50)  NULL,
    [Result]     INT           NULL,
    [UpdateTime] DATETIME      NULL,
    [CreateTime] DATETIME      NULL,
    [NeedAlert]  INT           NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

