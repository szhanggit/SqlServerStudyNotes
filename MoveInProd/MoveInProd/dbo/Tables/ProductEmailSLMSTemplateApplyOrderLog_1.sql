CREATE TABLE [dbo].[ProductEmailSLMSTemplateApplyOrderLog] (
    [Id]          BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TaskId]      BIGINT       NOT NULL,
    [ProductCode] VARCHAR (50) NULL,
    [OrderNumber] VARCHAR (50) NULL,
    [IsEmail]     INT          NULL,
    [Status]      INT          NULL,
    CONSTRAINT [PK_ProductEmailSLMSTemplateApplyOrderLog] PRIMARY KEY CLUSTERED ([Id] ASC),
    FOREIGN KEY ([TaskId]) REFERENCES [dbo].[ProductEmailSLMSTemplateApplyOrderTask] ([Id])
);

