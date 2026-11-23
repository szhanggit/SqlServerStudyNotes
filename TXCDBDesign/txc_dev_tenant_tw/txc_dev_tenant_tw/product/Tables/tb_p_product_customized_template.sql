CREATE TABLE [product].[tb_p_product_customized_template] (
    [product_customized_template_id] INT           IDENTITY (1, 1) NOT NULL,
    [product_id]                     INT           NOT NULL,
    [client_id]                      INT           NOT NULL,
    [template_id]                    INT           NOT NULL,
    [template_version_id]            INT           NOT NULL,
    [template_type]                  INT           NOT NULL,
    [template_sub_type]              INT           NOT NULL,
    [product_template_tag_value_id]  INT           NOT NULL,
    [created_by]                     NVARCHAR (50) NOT NULL,
    [created_on]                     DATETIME      NOT NULL,
    CONSTRAINT [PK_product_customized_template_id] PRIMARY KEY CLUSTERED ([product_customized_template_id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_product_customized_template_product_id]
    ON [product].[tb_p_product_customized_template]([product_id] ASC, [client_id] ASC);

