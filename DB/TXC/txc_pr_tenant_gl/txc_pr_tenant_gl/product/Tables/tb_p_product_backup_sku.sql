CREATE TABLE [product].[tb_p_product_backup_sku] (
    [product_sku_setting_id] INT            IDENTITY (1, 1) NOT NULL,
    [product_id]             INT            NOT NULL,
    [sku_id]                 INT            NOT NULL,
    [back_sequence]          INT            NOT NULL,
    [created_by]             NVARCHAR (250) NULL,
    [created_on]             DATETIME       NULL,
    CONSTRAINT [PK_product_sku_setting_id] PRIMARY KEY CLUSTERED ([product_sku_setting_id] ASC),
    CONSTRAINT [UK_product_id_sku_index] UNIQUE NONCLUSTERED ([product_id] ASC, [sku_id] ASC, [back_sequence] ASC)
);

