CREATE TABLE [backup].[tb_p_product_template_tag_value_set] (
    [product_template_tag_value_set_id] INT            IDENTITY (1, 1) NOT NULL,
    [product_template_tag_value_id]     INT            NOT NULL,
    [tag_id]                            INT            NOT NULL,
    [value]                             NVARCHAR (MAX) NULL,
    [text_value]                        NVARCHAR (MAX) NULL
);

