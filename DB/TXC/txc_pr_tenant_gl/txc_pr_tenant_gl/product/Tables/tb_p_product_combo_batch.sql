CREATE TABLE [product].[tb_p_product_combo_batch] (
    [product_id]               INT          NOT NULL,
    [child_product_id]         INT          NOT NULL,
    [child_product_version_id] INT          NOT NULL,
    [sequence]                 INT          NULL,
    [guid]                     VARCHAR (50) NOT NULL
);

