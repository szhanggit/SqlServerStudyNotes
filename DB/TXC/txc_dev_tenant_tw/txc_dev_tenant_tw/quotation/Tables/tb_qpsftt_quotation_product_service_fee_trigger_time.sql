CREATE TABLE [quotation].[tb_qpsftt_quotation_product_service_fee_trigger_time] (
    [id]                          INT             IDENTITY (1, 1) NOT NULL,
    [service_fee_trigger_time_id] INT             NOT NULL,
    [sold_price]                  NUMERIC (15, 4) NOT NULL,
    [sold_price_with_tax]         NUMERIC (15, 4) NOT NULL,
    [validity_from]               DATETIME        NOT NULL,
    [validity_end]                DATETIME        NOT NULL,
    [status]                      INT             NOT NULL,
    [created_by]                  NVARCHAR (50)   NOT NULL,
    [created_on]                  DATETIME        NOT NULL,
    [approved_by]                 NVARCHAR (50)   NULL,
    [approved_on]                 DATETIME        NULL,
    [quotation_product_id]        INT             NOT NULL,
    CONSTRAINT [PK_tb_qpsftt_quotation_product_service_fee_trigger_time] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_tb_qpsftt_quotation_product_service_fee_trigger_time_tb_qp_quotation_product] FOREIGN KEY ([quotation_product_id]) REFERENCES [quotation].[tb_qp_quotation_product] ([id])
);

