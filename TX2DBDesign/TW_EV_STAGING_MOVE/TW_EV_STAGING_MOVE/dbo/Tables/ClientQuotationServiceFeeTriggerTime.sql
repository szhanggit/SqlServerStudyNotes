CREATE TABLE [dbo].[ClientQuotationServiceFeeTriggerTime] (
    [Id]                      INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientQuotationId]       INT             NOT NULL,
    [ServiceFeeTriggerTimeId] INT             NOT NULL,
    [SoldPrice]               NUMERIC (15, 4) NOT NULL,
    [SoldPriceWithTax]        NUMERIC (15, 4) NOT NULL,
    [ValidityFrom]            DATETIME        NOT NULL,
    [ValidityEnd]             DATETIME        NOT NULL,
    [Status]                  TINYINT         NOT NULL,
    [CreatedBy]               NVARCHAR (50)   NULL,
    [CreatedOn]               DATETIME        NULL,
    [ApprovedBy]              NVARCHAR (50)   NULL,
    [ApprovedOn]              DATETIME        NULL,
    CONSTRAINT [PK_ClientQuotationServiceFeeTriggerTime_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ClientQuotationServiceFeeTriggerTime_ClientQuotation_ClientQuotationId] FOREIGN KEY ([ClientQuotationId]) REFERENCES [dbo].[ClientQuotation] ([Id]),
    CONSTRAINT [FK_ClientQuotationServiceFeeTriggerTime_ServiceFeeTriggerTime_ServiceFeeTriggerTimeId] FOREIGN KEY ([ServiceFeeTriggerTimeId]) REFERENCES [dbo].[ServiceFeeTriggerTime] ([Id])
);

