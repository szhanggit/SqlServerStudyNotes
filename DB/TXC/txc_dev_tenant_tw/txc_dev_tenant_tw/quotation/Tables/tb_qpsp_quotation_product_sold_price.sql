CREATE TABLE [quotation].[tb_qpsp_quotation_product_sold_price] (
    [id]                    INT             IDENTITY (1, 1) NOT NULL,
    [quotation_product_id]  INT             NOT NULL,
    [sold_price]            NUMERIC (15, 4) NOT NULL,
    [sold_price_with_tax]   NUMERIC (15, 4) NOT NULL,
    [sold_price_percentage] NUMERIC (10, 6) NULL,
    [face_value_range_from] INT             NULL,
    [face_value_range_to]   INT             NULL,
    [validity_from]         DATETIME        NOT NULL,
    [validity_end]          DATETIME        NOT NULL,
    [status]                INT             NOT NULL,
    [created_by]            NVARCHAR (50)   NOT NULL,
    [created_on]            DATETIME        NOT NULL,
    [approved_by]           NVARCHAR (50)   NULL,
    [approved_on]           DATETIME        NULL,
    CONSTRAINT [PK_tb_qpsp_quotation_product_sold_price] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_tb_qpsp_quotation_product_sold_price_tb_qp_quotation_product] FOREIGN KEY ([quotation_product_id]) REFERENCES [quotation].[tb_qp_quotation_product] ([id])
);

