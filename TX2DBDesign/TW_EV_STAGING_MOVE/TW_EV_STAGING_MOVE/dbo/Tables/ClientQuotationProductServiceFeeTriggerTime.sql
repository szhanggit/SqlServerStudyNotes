CREATE TABLE [dbo].[ClientQuotationProductServiceFeeTriggerTime] (
    [Id]                       INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientQuotationProductId] INT             NOT NULL,
    [ServiceFeeTriggerTimeId]  INT             NOT NULL,
    [SoldPrice]                NUMERIC (15, 4) NOT NULL,
    [SoldPriceWithTax]         NUMERIC (15, 4) NOT NULL,
    [ValidityFrom]             DATETIME        NOT NULL,
    [ValidityEnd]              DATETIME        NOT NULL,
    [Status]                   TINYINT         NOT NULL,
    [CreatedBy]                NVARCHAR (50)   NULL,
    [CreatedOn]                DATETIME        NULL,
    [ApprovedBy]               NVARCHAR (50)   NULL,
    [ApprovedOn]               DATETIME        NULL,
    CONSTRAINT [PK_ClientQuotationProductServiceFeeTriggerTime_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ClientQuotationProductServiceFee_ClientQuotationProduct_ClientQuotationProductId] FOREIGN KEY ([ClientQuotationProductId]) REFERENCES [dbo].[ClientQuotationProduct] ([Id]),
    CONSTRAINT [FK_ClientQuotationProductServiceFeeTriggerTime_ServiceFeeTriggerTime_ServiceFeeTriggerTimeId] FOREIGN KEY ([ServiceFeeTriggerTimeId]) REFERENCES [dbo].[ServiceFeeTriggerTime] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IDX_ClientQuotationProductServiceFeeTriggerTime_ValidityFrom]
    ON [dbo].[ClientQuotationProductServiceFeeTriggerTime]([ValidityFrom] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_ClientQuotationProductServiceFeeTriggerTime_ValidityEnd]
    ON [dbo].[ClientQuotationProductServiceFeeTriggerTime]([ValidityEnd] ASC);

