CREATE TABLE [product].[tb_p_product_combo] (
    [product_combo_id]         INT           IDENTITY (1, 1) NOT NULL,
    [product_id]               INT           NOT NULL,
    [child_product_id]         INT           NOT NULL,
    [child_product_version_id] INT           NOT NULL,
    [sequence]                 INT           NULL,
    [status]                   BIT           NOT NULL,
    [created_by]               VARCHAR (250) NULL,
    [created_on]               DATETIME      NULL,
    [last_updated_by]          VARCHAR (250) NULL,
    [last_updated_on]          DATETIME      NULL,
    [timestamp]                ROWVERSION    NOT NULL,
    CONSTRAINT [PK_tb_p_product_combo_id] PRIMARY KEY CLUSTERED ([product_combo_id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_tb_p_product_combo_child_product_id]
    ON [product].[tb_p_product_combo]([child_product_id] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_tb_p_product_combo_product_id]
    ON [product].[tb_p_product_combo]([product_id] ASC);

