CREATE TABLE [dbo].[ProductProcurementTrigger] (
    [Id]              INT             IDENTITY (1, 1) NOT NULL,
    [ProductId]       INT             NOT NULL,
    [Status]          TINYINT         NOT NULL,
    [RetryCount]      INT             NOT NULL,
    [CreatedDateTime] DATETIME        NOT NULL,
    [TriggerDateTime] DATETIME        NULL,
    [RetryDateTime]   DATETIME        NULL,
    [ClearDateTime]   DATETIME        NULL,
    [TriggerResponse] NVARCHAR (2000) NULL,
    CONSTRAINT [PK_ProductProcurementTrigger] PRIMARY KEY CLUSTERED ([Id] ASC)
);

