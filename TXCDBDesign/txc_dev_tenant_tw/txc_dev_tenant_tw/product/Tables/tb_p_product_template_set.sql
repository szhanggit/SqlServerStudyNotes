CREATE TABLE [product].[tb_p_product_template_set] (
    [product_template_set_id]     INT        IDENTITY (1, 1) NOT NULL,
    [product_template_id]         INT        NOT NULL,
    [template_type]               TINYINT    NOT NULL,
    [product_template_version_id] INT        NOT NULL,
    [template_sub_type]           TINYINT    NULL,
    [timestamp]                   ROWVERSION NOT NULL,
    CONSTRAINT [PK_tb_p_product_template_set_id] PRIMARY KEY CLUSTERED ([product_template_set_id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tb_p_product_template_set]
    ON [product].[tb_p_product_template_set]([product_template_id] ASC, [template_type] ASC, [template_sub_type] ASC);

