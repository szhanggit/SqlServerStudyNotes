CREATE TABLE [dbo].[ProductPricingValueBased] (
    [Id]                          INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FaceValue]                   INT             NOT NULL,
    [CustomerFeePrepaid]          NUMERIC (15, 4) NULL,
    [CustomerFeePostpaid]         NUMERIC (15, 4) NULL,
    [MerchantFee]                 NUMERIC (15, 4) NOT NULL,
    [FaceValueWithTax]            INT             NOT NULL,
    [SellingPricePrepaid]         NUMERIC (15, 4) NULL,
    [SellingPricePrepaidWithTax]  NUMERIC (15, 4) NULL,
    [CustomerFeePrepaidWithTax]   NUMERIC (15, 4) NULL,
    [SellingPricePostpaid]        NUMERIC (15, 4) NULL,
    [SellingPricePostpaidWithTax] NUMERIC (15, 4) NULL,
    [CustomerFeePostpaidWithTax]  NUMERIC (15, 4) NULL,
    [MerchantFeeWithTax]          NUMERIC (15, 4) NOT NULL,
    CONSTRAINT [PK_PRODUCTPRICINGVALUEBASED] PRIMARY KEY CLUSTERED ([Id] ASC)
);

