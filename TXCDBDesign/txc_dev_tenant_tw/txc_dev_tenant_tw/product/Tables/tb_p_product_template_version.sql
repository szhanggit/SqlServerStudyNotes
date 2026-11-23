CREATE TABLE [product].[tb_p_product_template_version] (
    [product_template_version_id]   INT        IDENTITY (1, 1) NOT NULL,
    [template_version_id]           INT        NOT NULL,
    [product_template_tag_value_id] INT        NULL,
    [timestamp]                     ROWVERSION NOT NULL,
    CONSTRAINT [PK_tb_p_product_template_version_id] PRIMARY KEY CLUSTERED ([product_template_version_id] ASC)
);

