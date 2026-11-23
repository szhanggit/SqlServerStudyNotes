CREATE TABLE [dbo].[ClientQuotationProductSoldPrice] (
    [Id]                            INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
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
    [FaceValueRangeTo]              INT             NULL,
    CONSTRAINT [PK_ClientQuotationProductSoldPrice_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ClientQuotationProductSoldPrice_ClientQuotationProduct_ClientQuotationProductId] FOREIGN KEY ([ClientQuotationProductId]) REFERENCES [dbo].[ClientQuotationProduct] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IDC_ClientQuotationProductSoldPrice_ValidityEnd]
    ON [dbo].[ClientQuotationProductSoldPrice]([ValidityEnd] ASC);


GO
CREATE NONCLUSTERED INDEX [IDC_ClientQuotationProductSoldPrice_ValidityFrom]
    ON [dbo].[ClientQuotationProductSoldPrice]([ValidityFrom] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_ClientQuotationProductSoldPrice_Validity]
    ON [dbo].[ClientQuotationProductSoldPrice]([Status] ASC, [ValidityFrom] ASC, [ValidityEnd] ASC, [Id] ASC)
    INCLUDE([SoldPriceWithoutTax], [ClientQuotationProductId]);

