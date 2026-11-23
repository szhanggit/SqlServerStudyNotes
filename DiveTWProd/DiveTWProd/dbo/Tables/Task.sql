CREATE TABLE [dbo].[Task] (
    [Id]                BIGINT         IDENTITY (1, 1) NOT NULL,
    [ConsumerId]        INT            NOT NULL,
    [ServiceProviderId] INT            NOT NULL,
    [TaskPriority]      INT            NOT NULL,
    [TaskStatus]        INT            NOT NULL,
    [MessageType]       INT            NOT NULL,
    [EmailTemplateId]   BIGINT         NULL,
    [SLMSTemplateId]    BIGINT         NULL,
    [MMSTemplateId]     BIGINT         NULL,
    [TaskLocalId]       BIGINT         NOT NULL,
    [ScheduledDate]     NVARCHAR (8)   NOT NULL,
    [ScheduledTime]     NVARCHAR (6)   NOT NULL,
    [ScheduledDateTime] DATETIME       NOT NULL,
    [TimezoneOffset]    VARCHAR (6)    NULL,
    [CreatedOn]         DATETIME       NOT NULL,
    [ProcessedOn]       DATETIME       NULL,
    [MessageNumber]     INT            NOT NULL,
    [TriedCount]        INT            DEFAULT ((0)) NOT NULL,
    [Comment]           NVARCHAR (500) NULL,
    CONSTRAINT [PK_Task] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Task_Consumer_ConsumerId] FOREIGN KEY ([ConsumerId]) REFERENCES [dbo].[Consumer] ([Id]),
    CONSTRAINT [FK_Task_EmailMessageTemplate_EmailTemplateId] FOREIGN KEY ([EmailTemplateId]) REFERENCES [dbo].[EmailMessageTemplate] ([Id]),
    CONSTRAINT [FK_Task_ServiceProvider_ServiceProviderId] FOREIGN KEY ([ServiceProviderId]) REFERENCES [dbo].[ServiceProvider] ([Id]),
    CONSTRAINT [FK_Task_SLMSMessageTemplate_SLMSTemplateId] FOREIGN KEY ([SLMSTemplateId]) REFERENCES [dbo].[SLMSMessageTemplate] ([Id]),
    CONSTRAINT [UK_Task_ConsumerId_TaskLocalId] UNIQUE NONCLUSTERED ([ConsumerId] ASC, [TaskLocalId] ASC, [MessageType] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Task_EmailTemplateId]
    ON [dbo].[Task]([EmailTemplateId] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Task_SLMSTemplateId]
    ON [dbo].[Task]([SLMSTemplateId] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Task_TaskStatus]
    ON [dbo].[Task]([TaskStatus] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0--High
   1--Normal
   2--Low', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'TaskPriority';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--Initialized
   2--Sending
   3--Sent Success
   4--Sent Failed
   5--Sent Partly Success
   6--Trashed
   7--ToBeResentAll
   8--ToBeResentFail
   9--Unknown', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'TaskStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--Email
   2--SMS
   3--MMS
   4--LMS', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Task', @level2type = N'COLUMN', @level2name = N'MessageType';

