CREATE TABLE [dbo].[TaskActionLog] (
    [Id]                  BIGINT         IDENTITY (1, 1) NOT NULL,
    [TaskId]              BIGINT         NOT NULL,
    [ActionType]          INT            NOT NULL,
    [ActionResult]        INT            NULL,
    [Operator]            NVARCHAR (50)  NOT NULL,
    [ActionStartDate]     NVARCHAR (8)   NULL,
    [ActionStartTime]     NVARCHAR (6)   NULL,
    [ActionStartDateTime] DATETIME       NULL,
    [ActionEndDate]       NVARCHAR (8)   NULL,
    [ActionEndTime]       NVARCHAR (6)   NULL,
    [ActionEndDateTime]   DATETIME       NULL,
    [Comment]             NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_TaskActionLog] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TaskActionLog_Task_TaskId] FOREIGN KEY ([TaskId]) REFERENCES [dbo].[Task] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_TaskActionLog_TaskId]
    ON [dbo].[TaskActionLog]([TaskId] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0--Create
   1--Process
   2--Trash
   3--Consumer Query', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TaskActionLog', @level2type = N'COLUMN', @level2name = N'ActionType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0--failed
   1--success
   2--unknown', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TaskActionLog', @level2type = N'COLUMN', @level2name = N'ActionResult';

