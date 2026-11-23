CREATE TABLE [dbo].[ClientQuotationProductSoldPrice20211009] (
    [Id]                            INT             IDENTITY (1, 1) NOT NULL,
    [ClientQuotationProductId]      INT             NOT NULL,
    [SoldPriceWithoutTax]           NUMERIC (15, 4) NULL,
    [SoldPriceWithTax]              NUMERIC (15, 4) NULL,
    [ValueBasedSoldPriceWithoutTax] NUMERIC (15, 4) NULL,
    [ValueBasedSoldPriceWithTax]    NUMERIC (15, 4) NULL,
    [ValidityFrom]                  DATETIME        NOT NULL,
    [ValidityEnd]                   DATETIME        NOT NULL,
    [Status]                        TINYINT         NOT NULL,
    [CreatedBy]                     NVARCHAR (50)   NULL,
    [CreatedOn]                     DATETIME        NULL,
    [ApprovedBy]                    NVARCHAR (50)   NULL,
    [ApprovedOn]                    DATETIME        NULL,
    [SoldPricePercentage]           DECIMAL (10, 6) NULL,
    [FaceValueRangeFrom]            INT             NULL,
    [FaceValueRangeTo]              INT             NULL
);

