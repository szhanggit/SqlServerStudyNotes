CREATE TABLE [product].[tb_p_product_template_tag_value_set] (
    [product_template_tag_value_set_id] INT            IDENTITY (1, 1) NOT NULL,
    [product_template_tag_value_id]     INT            NOT NULL,
    [tag_id]                            INT            NOT NULL,
    [value]                             NVARCHAR (MAX) NULL,
    [text_value]                        NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_product_template_tag_value_set_id] PRIMARY KEY CLUSTERED ([product_template_tag_value_set_id] ASC),
    CONSTRAINT [UK_product_template_tag_value_set] UNIQUE NONCLUSTERED ([product_template_tag_value_id] ASC, [tag_id] ASC)
);

