CREATE TYPE [product].[product_backup_sku_type] AS TABLE (
    [product_id]    INT NOT NULL,
    [sku_id]        INT NOT NULL,
    [back_sequence] INT NOT NULL,
    PRIMARY KEY CLUSTERED ([product_id] ASC, [sku_id] ASC, [back_sequence] ASC));

