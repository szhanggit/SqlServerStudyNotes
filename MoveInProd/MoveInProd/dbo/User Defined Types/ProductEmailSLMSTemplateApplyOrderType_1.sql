CREATE TYPE [dbo].[ProductEmailSLMSTemplateApplyOrderType] AS TABLE (
    [Id]          INT          NOT NULL,
    [RecordId]    INT          NULL,
    [BatchLogId]  INT          NULL,
    [ProductCode] VARCHAR (50) NULL,
    [OrderNumber] VARCHAR (50) NULL,
    [IsEmail]     INT          NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC));

