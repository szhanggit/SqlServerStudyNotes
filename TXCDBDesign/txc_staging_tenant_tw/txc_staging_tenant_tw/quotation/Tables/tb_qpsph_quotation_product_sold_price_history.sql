CREATE TABLE [quotation].[tb_qpsph_quotation_product_sold_price_history] (
    [id]                      INT             IDENTITY (1, 1) NOT NULL,
    [quotation_product_id]    INT             NOT NULL,
    [sold_price]              NUMERIC (15, 4) NOT NULL,
    [sold_price_with_tax]     NUMERIC (15, 4) NOT NULL,
    [new_sold_price]          NUMERIC (15, 4) NOT NULL,
    [new_sold_price_with_tax] NUMERIC (15, 4) NOT NULL,
    [approved_by]             NVARCHAR (50)   NULL,
    [approved_on]             DATETIME        NULL,
    CONSTRAINT [PK_tb_qpsph_quotation_product_sold_price_history] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_tb_qpsph_quotation_product_sold_price_history_tb_qp_quotation_product] FOREIGN KEY ([quotation_product_id]) REFERENCES [quotation].[tb_qp_quotation_product] ([id])
);

