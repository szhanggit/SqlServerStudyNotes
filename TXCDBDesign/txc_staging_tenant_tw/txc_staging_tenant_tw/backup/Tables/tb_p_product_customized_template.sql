CREATE TABLE [backup].[tb_p_product_customized_template] (
    [product_customized_template_id] INT           IDENTITY (1, 1) NOT NULL,
    [product_id]                     INT           NOT NULL,
    [client_id]                      INT           NOT NULL,
    [template_id]                    INT           NOT NULL,
    [template_version_id]            INT           NOT NULL,
    [template_type]                  INT           NOT NULL,
    [template_sub_type]              INT           NOT NULL,
    [product_template_tag_value_id]  INT           NOT NULL,
    [created_by]                     NVARCHAR (50) NOT NULL,
    [created_on]                     DATETIME      NOT NULL
);

