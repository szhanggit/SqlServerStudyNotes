CREATE TABLE [dbo].[TXCSKUFaceValueMultiplierSync] (
    [RunId]                           VARCHAR (50)    NULL,
    [SKUId]                           INT             NULL,
    [FaceValueWithTax]                DECIMAL (18, 2) NULL,
    [FaceValueWithOutTax]             DECIMAL (20, 4) NULL,
    [Multiplier]                      INT             NULL,
    [TXCProductId]                    INT             NULL,
    [TX2ProductId]                    INT             NULL,
    [TX2ProductPricingProductBasedId] INT             NULL,
    [TX2ProductPricingValueBasedId]   INT             NULL
);

