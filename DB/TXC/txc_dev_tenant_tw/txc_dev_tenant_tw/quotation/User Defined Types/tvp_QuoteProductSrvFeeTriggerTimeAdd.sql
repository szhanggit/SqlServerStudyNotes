CREATE TYPE [quotation].[tvp_QuoteProductSrvFeeTriggerTimeAdd] AS TABLE (
    [ServiceFeeTriggerTimeId] INT             NOT NULL,
    [SoldPrice]               NUMERIC (15, 4) NOT NULL,
    [SoldPriceWithTax]        NUMERIC (15, 4) NOT NULL,
    [ValidityFrom]            DATETIME        NOT NULL,
    [ValidityEnd]             DATETIME        NOT NULL,
    [Status]                  INT             NOT NULL,
    [CreatedBy]               NVARCHAR (50)   NOT NULL,
    [CreatedOn]               DATETIME        NOT NULL,
    [ApprovedBy]              NVARCHAR (50)   NULL,
    [ApprovedOn]              DATETIME        NULL);

