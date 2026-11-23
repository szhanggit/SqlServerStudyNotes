CREATE TABLE [quotation].[tb_qpc_quotation_product_combo] (
    [id]                                INT           IDENTITY (1, 1) NOT NULL,
    [quotation_product_id]              INT           NOT NULL,
    [child_client_quotation_product_id] INT           NOT NULL,
    [product_combos_set_id]             INT           NOT NULL,
    [business_model_id]                 INT           NOT NULL,
    [expiry_scheme_id]                  INT           NOT NULL,
    [expiration_date]                   DATETIME      NULL,
    [sequence]                          INT           NULL,
    [customization_product_id]          INT           NULL,
    [updated_by]                        NVARCHAR (50) NULL,
    [updated_on]                        DATETIME      NULL,
    CONSTRAINT [PK_tb_qpc_quotation_product_combo] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_tb_qpc_quotation_product_combo_tb_qp_quotation_product] FOREIGN KEY ([quotation_product_id]) REFERENCES [quotation].[tb_qp_quotation_product] ([id])
);

