CREATE TYPE [quotation].[tvp_BatchQuoteProductSoldPriceAdd] AS TABLE (
    [MasterProductCode]   NVARCHAR (250)  NOT NULL,
    [ProductVersionId]    INT             NOT NULL,
    [SoldPrice]           NUMERIC (15, 4) NOT NULL,
    [SoldPriceWithTax]    NUMERIC (15, 4) NOT NULL,
    [SoldPricePercentage] NUMERIC (10, 6) NULL,
    [FaceValueRangeFrom]  INT             NULL,
    [FaceValueRangeTo]    INT             NULL,
    [ValidityFrom]        DATETIME        NOT NULL,
    [ValidityEnd]         DATETIME        NOT NULL,
    [Status]              INT             NOT NULL);

