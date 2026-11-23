CREATE TABLE [dbo].[EmailMessageActionLog] (
    [Id]                  BIGINT         IDENTITY (1, 1) NOT NULL,
    [MessageId]           BIGINT         NOT NULL,
    [ActionType]          INT            NOT NULL,
    [ActionResult]        INT            NULL,
    [Operator]            NVARCHAR (50)  NOT NULL,
    [ActionStartDate]     NVARCHAR (8)   NULL,
    [ActionStartTime]     NVARCHAR (6)   NULL,
    [ActionStartDateTime] DATETIME       NULL,
    [ActionEndDate]       NVARCHAR (8)   NULL,
    [ActionEndTime]       NVARCHAR (6)   NULL,
    [ActionEndDateTime]   DATETIME       NULL,
    [Comment]             NVARCHAR (500) NULL,
    CONSTRAINT [PK_MessageEmailActionLog] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EmailMessageActionLog_EmailMessage_MessageId] FOREIGN KEY ([MessageId]) REFERENCES [dbo].[EmailMessage] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_EmailMessageActionLog_MessageId]
    ON [dbo].[EmailMessageActionLog]([MessageId] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0--Create
   1--Send
   2--Trash
   3--Resend
   4--Consumer Query
   5--Query SP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EmailMessageActionLog', @level2type = N'COLUMN', @level2name = N'ActionType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0--failed
   1--success
   2--unknown', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EmailMessageActionLog', @level2type = N'COLUMN', @level2name = N'ActionResult';

