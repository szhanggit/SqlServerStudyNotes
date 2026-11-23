CREATE TABLE [dbo].[TaskActionLogArchive] (
    [Id]                  BIGINT         NOT NULL,
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
    [Comment]             NVARCHAR (MAX) NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [IX_TaskActionLogArchive]
    ON [dbo].[TaskActionLogArchive]([Id] ASC) WITH (IGNORE_DUP_KEY = ON);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0--Create
   1--Process
   2--Trash
   3--Consumer Query', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TaskActionLogArchive', @level2type = N'COLUMN', @level2name = N'ActionType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0--failed
   1--success
   2--unknown', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TaskActionLogArchive', @level2type = N'COLUMN', @level2name = N'ActionResult';

