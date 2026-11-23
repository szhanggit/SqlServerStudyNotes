CREATE TABLE [backup].[tb_p_product_template_set] (
    [product_template_set_id]     INT     IDENTITY (1, 1) NOT NULL,
    [product_template_id]         INT     NOT NULL,
    [template_type]               TINYINT NOT NULL,
    [product_template_version_id] INT     NULL,
    [template_sub_type]           TINYINT NULL
);

