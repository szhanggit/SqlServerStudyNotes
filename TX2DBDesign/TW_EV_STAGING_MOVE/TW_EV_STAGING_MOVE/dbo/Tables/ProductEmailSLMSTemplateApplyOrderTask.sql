CREATE TABLE [dbo].[ProductEmailSLMSTemplateApplyOrderTask] (
    [Id]         BIGINT   IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CreateDate] DATETIME NOT NULL,
    [StartDate]  DATETIME NULL,
    [EndDate]    DATETIME NULL,
    [TaskStatus] INT      NULL,
    CONSTRAINT [PK_ProductEmailSLMSTemplateApplyOrderTask] PRIMARY KEY CLUSTERED ([Id] ASC)
);

