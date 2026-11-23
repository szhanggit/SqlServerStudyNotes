CREATE TABLE [dbo].[TXCProductPriceSync] (
    [RunId]                       VARCHAR (50)    NOT NULL,
    [TXCProductPriceId]           INT             NULL,
    [FaceValue]                   INT             NULL,
    [FaceValueWithTax]            INT             NULL,
    [SellingPricePrepaid]         NUMERIC (15, 4) NULL,
    [SellingPricePrepaidWithTax]  NUMERIC (15, 4) NULL,
    [SellingPricePostpaid]        NUMERIC (15, 4) NULL,
    [SellingPricePostpaidWithTax] NUMERIC (15, 4) NULL,
    [Cost]                        NUMERIC (15, 4) NULL,
    [CostWithTax]                 NUMERIC (15, 4) NULL,
    [CustomerFeePrepaid]          NUMERIC (15, 4) NULL,
    [CustomerFeePrepaidWithTax]   NUMERIC (15, 4) NULL,
    [CustomerFeePostpaid]         NUMERIC (15, 4) NULL,
    [CustomerFeePostpaidWithTax]  NUMERIC (15, 4) NULL,
    [MerchantFee]                 NUMERIC (15, 4) NULL,
    [MerchantFeeWithTax]          NUMERIC (15, 4) NULL,
    [Balance]                     INT             NULL,
    [DefaultSellingPrice]         NUMERIC (15, 4) NULL,
    [DefaultProductCost]          NUMERIC (15, 4) NULL
);


GO
CREATE CLUSTERED INDEX [IX_TXCProductPriceSync]
    ON [dbo].[TXCProductPriceSync]([RunId] ASC, [TXCProductPriceId] ASC) WITH (FILLFACTOR = 90);

