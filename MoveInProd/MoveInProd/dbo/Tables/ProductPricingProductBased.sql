CREATE TABLE [dbo].[ProductPricingProductBased] (
    [Id]                          INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FaceValue]                   INT             NOT NULL,
    [SellingPricePrepaid]         NUMERIC (15, 4) NULL,
    [SellingPricePostpaid]        NUMERIC (15, 4) NULL,
    [Cost]                        NUMERIC (15, 4) NOT NULL,
    [FaceValueWithTax]            INT             NOT NULL,
    [SellingPricePrepaidWithTax]  NUMERIC (15, 4) NULL,
    [SellingPricePostpaidWithTax] NUMERIC (15, 4) NULL,
    [CostWithTax]                 NUMERIC (15, 4) NOT NULL,
    [Balance]                     INT             NOT NULL,
    CONSTRAINT [PK_PRODUCTPRICINGPRODUCTBASED] PRIMARY KEY CLUSTERED ([Id] ASC)
);

