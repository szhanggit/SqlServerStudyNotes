CREATE TABLE [product].[tb_p_product_price] (
    [product_price_id]                INT             IDENTITY (1, 1) NOT NULL,
    [selling_price_prepaid]           DECIMAL (15, 4) NULL,
    [selling_price_prepaid_with_tax]  DECIMAL (15, 4) NULL,
    [selling_price_postpaid]          DECIMAL (15, 4) NULL,
    [selling_price_postpaid_with_tax] DECIMAL (15, 4) NULL,
    [customer_fee_prepaid]            DECIMAL (15, 4) NULL,
    [customer_fee_prepaid_with_tax]   DECIMAL (15, 4) NULL,
    [customer_fee_postpaid]           DECIMAL (15, 4) NULL,
    [customer_fee_postpaid_with_tax]  DECIMAL (15, 4) NULL,
    [timestamp]                       ROWVERSION      NOT NULL,
    CONSTRAINT [PK_product_price_id] PRIMARY KEY CLUSTERED ([product_price_id] ASC)
);

